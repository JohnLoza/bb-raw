class BbEntryReportsController < ApplicationController
  before_action :reset_breadcrumbs

  def index
    deny_access! and return unless current_user.has_role?(User::ROLES[:formulation], or: [User::ROLES[:packing]])

    @reports = BbEntryReport.active.recent
      .search(key_words: search_params, fields: [:hash_id]).page(params[:page]).includes(:user, :authorizer)
  end

  def show
    deny_access! and return unless current_user.has_role?(User::ROLES[:formulation], or: [User::ROLES[:packing]])

    @report = find_report
    add_breadcrumb(@report.hash_id)
  end

  def new
    deny_access! and return unless current_user.has_role?(User::ROLES[:formulation])

    @report = current_user.bb_entry_reports.new
    @bb_products = BbProduct.active.a_z
    add_breadcrumb(t('.title'))
  end

  def create
    deny_access! and return unless current_user.has_role?(User::ROLES[:formulation])

    @report = current_user.bb_entry_reports.new
    params.keys.each do |key|
      next unless key.include?('detail_')
      detail = @report.details.new(detail_params(key))
      redirect_to new_bb_entry_report_path and return unless is_batch_correct?(detail)
      @report.details << detail
    end

    begin
      if @report.save!
        redirect_to bb_entry_reports_path, flash: {success: t('.success')}
      else
        redirect_to bb_entry_reports_path, flash: {danger: 'Error::NotValid::Save'}
      end
    rescue ActiveRecord::RecordInvalid
      redirect_to bb_entry_reports_path, flash: {danger: 'Error::NotValid::Rescue'}
    end
  end

  def destroy
    deny_access! and return unless current_user.has_role?(User::ROLES[:formulation])

    @report = find_report
    if @report.user_id == current_user.id and @report.destroy
      flash[:success] = t('.success')
    else
      flash[:warning] = t('.failure')
    end
    redirect_to bb_entry_reports_path
  end

  def authorize!
    deny_access! and return unless current_user.has_role?(User::ROLES[:packing])

    @report = find_report
    redirect_to root_path and return if @report.authorized?

    if @report.authorize!(current_user)
      flash[:success] = t('.success')
    else
      flash[:failure] = t('.failure')
    end
    redirect_to bb_entry_reports_path
  end

  private
  def find_report
    BbEntryReport.find_by!(hash_id: params[:id])
  end

  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(BbProduct), bb_products_path)
    add_breadcrumb(label_for_model(BbEntryReport), bb_entry_reports_path)
  end

  def detail_params(key)
    params.require(key).permit(:bb_product_id, :batch, :units)
  end

  def is_batch_correct?(detail)
    fp = FormulationProcess.find_by(batch: detail.batch)
    # verify the batch is valid from a formulation process
    flash[:warning] = t('.wrong_batch', batch: detail.batch) and return false unless fp
    # verify the batch is not registered yet in stock.
    flash[:warning] = t('.batch_already_registered', batch: detail.batch) and return false if BbStock.find_by(batch: detail.batch)

    # set the correct expiration date from the formulation process
    detail.expiration_date = fp.prorated_expiration_date
    return true
  end

end
