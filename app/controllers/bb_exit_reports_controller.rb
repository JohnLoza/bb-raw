class BbExitReportsController < ApplicationController
  before_action :reset_breadcrumbs

  def index
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse], or: [User::ROLES[:administration]])

    @reports = BbExitReport.active.recent
      .search(key_words: search_params, fields: [:hash_id])
      .page(params[:page]).includes(:user, :authorizer)
  end

  def show
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse], or: [User::ROLES[:administration]])

    @report = find_report
    add_breadcrumb(@report.hash_id)
  end

  def new
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse])

    @report = current_user.bb_exit_reports.new
    @bb_products = BbProduct.active.a_z
    add_breadcrumb(t('.title'))
  end

  def create
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse])

    @report = current_user.bb_exit_reports.new
    @report.destiny = params[:bb_exit_report][:destiny]
    params.keys.each do |key|
      next unless key.include?('detail_')
      detail = @report.details.new(detail_params(key))
      unless BbStock.find_by(bb_product_id: detail.bb_product_id, batch: detail.batch)
        flash[:warning] = t('.product_not_found', batch: detail.batch)
        redirect_to new_bb_exit_report_path and return
      end
      @report.details << detail
    end

    begin
      if @report.save!
        redirect_to bb_exit_reports_path, flash: {success: t('.success')}
      else
        redirect_to bb_exit_reports_path, flash: {danger: 'Error::NotValid::Save'}
      end
    rescue ActiveRecord::RecordInvalid
      redirect_to bb_exit_reports_path, flash: {danger: 'Error::NotValid::Rescue'}
    end
  end

  def destroy
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse])

    @report = find_report
    if @report.user_id == current_user.id and @report.destroy
      flash[:success] = t('.success')
    else
      flash[:warning] = t('.failure')
    end
    redirect_to bb_exit_reports_path
  end

  def authorize!
    deny_access! and return unless current_user.has_role?(User::ROLES[:exit_authorization])

    @report = find_report
    redirect_to root_path and return if @report.authorized?

    begin
      ActiveRecord::Base.transaction do
        @report.authorize!(current_user)
        flash[:success] = t('.success')
      end
    rescue StandardError => e
      flash[:warning] = e.message
    end

    redirect_to bb_exit_reports_path
  end

  private
  def find_report
    BbExitReport.find_by!(hash_id: params[:id])
  end

  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(BbProduct), bb_products_path)
    add_breadcrumb(label_for_model(BbExitReport), bb_exit_reports_path)
  end

  def detail_params(key)
    params.require(key).permit(:bb_product_id, :batch, :units)
  end

end
