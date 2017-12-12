class SuppliesController < ApplicationController
  before_action :load_development_order
  before_action :reset_breadcrumbs

  def index
    @supplies = @order.supplies.includes(stock: {product: :provider})
    @supplier = @order.supplier if @order.supplied?
    @authorizer = @order.supplies_authorizer if @order.supplies_authorized?
    add_breadcrumb(t('.title'))
  end

  def new
    @supply = @order.supplies.new
    @providers = Provider.active.a_z
    add_breadcrumb(t('.title'))
  end

  def create
    redirect_to root_path and return if @order.supplied?

    begin
      stock = load_stock
      stock.each do |s|
        raise StandardError, t('.no_enough_stock', product: s.product, batch: s.batch) unless s.enough_stock?
      end

      ActiveRecord::Base.transaction do
        stock.each do |s|
          Supply.create!(development_order_id: @order.id, stock_id: s.id,
            bulk: s.required_bulk)
        end
        @order.set_supplier(@current_user)
        flash[:success] = t('.success')
      end
    rescue StandardError => e
      flash[:warning] = e.message
    end

    redirect_to development_orders_path
  end

  def authorize!
    @supplies = @order.supplies.includes(:stock)
    redirect_to root_path and return if @order.supplies_authorized?

    begin
      ActiveRecord::Base.transaction do
        @supplies.each do |supply|
          supply.stock.withdraw(supply.bulk)
        end
        @order.set_supplies_authorizer(@current_user)
        flash[:success] = t('.success')
      end
    rescue StandardError => e
      flash[:warning] = e.message
    end

    redirect_to development_orders_path
  end

  def return!
    redirect_to root_path and return unless @order.supplied?

    ActiveRecord::Base.transaction do
      @order.supplies.destroy_all
      @order.update_attributes(supplier_id: nil, supplied_at: nil)
      flash[:success] = t('.success')
    end

    redirect_to development_orders_path
  end

  private
  def load_development_order
    @order = DevelopmentOrder.find_by!(hash_id: params[:development_order_id])
  end

  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(DevelopmentOrder), development_orders_path)
    add_breadcrumb(@order, development_order_path(@order))
  end

  def load_stock
    stock_array = Array.new

    params.keys.each do |key|
      next unless key.include? 'product_'
      stock = Stock.where(product_id: params[key][:product_id], batch: params[key][:batch]).take

      unless stock
        product = Product.find(params[key][:product_id])
        raise StandardError, t('.stock_not_found', product: product, batch: params[key][:batch])
      end

      stock.required_bulk = params[key][:bulk].to_f
      stock_array << stock
    end

    return stock_array
  end
end
