class EntryProductReportsController < ApplicationController
  before_action :reset_breadcrumbs

  def index
    @reports = EntryProductReport.active.recent
      .search(search_params, :hash_id).page(params[:page]).includes(:user, :authorizer)
  end

  def show
    @report = find_report
    add_breadcrumb(@report.hash_id)
  end

  def new
    @report = @current_user.entry_product_reports.new
    @providers = Provider.all
    add_breadcrumb(t('.title'))
  end

  def create
    @report = @current_user.entry_product_reports.new
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
    @report = find_report
    if @report.destroy
      flash[:success] = t('.success')
    else
      flash[:warning] = t('.failure')
    end
    redirect_to entry_product_reports_path
  end

  def authorize!
    @report = find_report
    if @report.authorize!(@current_user)
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
    params.require(key).permit(:provider_product_id, :batch, :expiration_date,
      :invoice_folio, :invoice_date, :tare, :bulk)
  end

end
