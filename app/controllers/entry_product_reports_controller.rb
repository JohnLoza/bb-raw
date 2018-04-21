class EntryProductReportsController < ApplicationController
  before_action :reset_breadcrumbs

  def index
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse], or: [User::ROLES[:administration]])

    @reports = EntryProductReport.active.recent
      .search(key_words: search_params, fields: [:hash_id]).page(params[:page]).includes(:user, :authorizer)
  end

  def show
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse], or: [User::ROLES[:administration]])

    @report = find_report
    add_breadcrumb(@report.hash_id)
  end

  def new
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse])

    @report = current_user.entry_product_reports.new
    @providers = Provider.active.a_z
    add_breadcrumb(t('.title'))
  end

  def create
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse])

    @report = current_user.entry_product_reports.new
    params.keys.each do |key|
      next unless key.include?('detail_')
      @report.details << @report.details.new(detail_params(key))
    end

    begin
      if @report.save!
        redirect_to entry_product_reports_path, flash: {success: t('.success')}
      else
        redirect_to entry_product_reports_path, flash: {danger: 'Error::NotValid::Save'}
      end
    rescue ActiveRecord::RecordInvalid
      redirect_to entry_product_reports_path, flash: {danger: 'Error::NotValid::Rescue'}
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
    redirect_to entry_product_reports_path
  end

  def authorize!
    deny_access! and return unless current_user.has_role?(User::ROLES[:entry_authorization])

    @report = find_report
    redirect_to root_path and return if @report.authorized?

    if @report.authorize!(current_user)
      flash[:success] = t('.success')
    else
      flash[:failure] = t('.failure')
    end
    redirect_to entry_product_reports_path
  end

  private
  def find_report
    EntryProductReport.find_by!(hash_id: params[:id])
  end

  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(EntryProductReport), entry_product_reports_path)
  end

  def detail_params(key)
    params.require(key).permit(:product_id, :batch, :expiration_date,
      :invoice_folio, :invoice_date, :tare, :bulk)
  end

end
