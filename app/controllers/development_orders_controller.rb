class DevelopmentOrdersController < ApplicationController
  before_action :reset_breadcrumbs

  def index
    boolean = false
    if params[:only_authorized].present?
      boolean = true
      add_breadcrumb(t('.only_authorized'), development_orders_path(only_authorized: true))
    end

    @orders = DevelopmentOrder.active.authorized(boolean).not_supplied_first
      .order_by_required_date.search(search_params, :hash_id, :required_date)
      .page(params[:page]).includes(:user, :supplier, :supplies_authorizer)
  end

  def show
    @order = find_order
    add_breadcrumb(@order)

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "development_order_#{@order.hash_id}"
      end
    end
  end

  def new
    @order = current_user.development_orders.new
    @main_categories = Category.active.main_categories.a_z
    add_breadcrumb(t('.title'))
  end

  def create
    @order = current_user.development_orders.new(development_order_params)
    params.keys.each do |key|
      next unless key.include?('product_')
      @order.required_products << @order.required_products.new(required_product_params(key))
    end

    begin
      if @order.save!
        redirect_to development_orders_path, flash: {success: t('.success')}
      else
        redirect_to development_orders_path, flash: {danger: 'Error::NotValid::Save'}
      end
    rescue ActiveRecord::RecordInvalid
      redirect_to development_orders_path, flash: {danger: 'Error::NotValid::Rescue'}
    end
  end

  def destroy
    @order = find_order
    if @order.destroy
      flash[:success] = t('.success')
    else
      flash[:warning] = t('.failure')
    end
    redirect_to development_orders_path
  end

  def my_authorized_orders
    add_breadcrumb(t('.title'), my_authorized_development_orders_path)
    params[:controller] = 'formulation_processes'

    boolean = false
    if params[:closed_processes].present?
      boolean = true
      add_breadcrumb(t('.closed_processes'))
    end

    @orders = DevelopmentOrder.active.authorized(true).by_user(current_user.id)
      .with_closed_processes(boolean).order_by_required_date
      .search(search_params, :hash_id, :required_date)
      .page(params[:page]).includes(:supplier, :supplies_authorizer)
  end

  def finish_formulation_processes!
    @order = find_order
    redirect_to root_path and return if @order.formulation_processes_finished?

    @order = find_order
    if @order.update_attributes(formulation_processes_finished_at: Time.now)
      flash[:success] = t('.success')
    else
      flash[:failure] = t('.failure')
    end

    redirect_to my_authorized_development_orders_path
  end

  private
  def find_order
    DevelopmentOrder.find_by!(hash_id: params[:id])
  end

  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(DevelopmentOrder), development_orders_path)
  end

  def development_order_params
    params.require(:development_order).permit(:description, :required_date)
  end

  def required_product_params(key)
    params.require(key).permit(:product, :bulk)
  end
end
