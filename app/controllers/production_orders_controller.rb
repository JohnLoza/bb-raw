class ProductionOrdersController < ApplicationController
  before_action :reset_breadcrumbs, except: :tags

  def index
    @formulation_processes = FormulationProcess.for_transformation(false)
      .on_production(params[:on_production]).ancient
      .page(params[:page]).includes(:user, :development_order)

    @title = params[:on_production] ? t('.packed') : t('.not_packed')
  end

  def show
    @fp = FormulationProcess.find_by!(hash_id: params[:id])
    @production_order = ProductionOrder.find_by!(formulation_process_id: @fp.id)

    respond_to do |format|
      format.any { render_404 }
      format.pdf do
        render pdf: "production_order_#{@production_order.hash_id}"
      end
    end
  end

  def new
    add_breadcrumb(t('.title'))
    @fp = FormulationProcess.find_by!(hash_id: params[:fp])
    @production_order = ProductionOrder.new
    @production_order.created_at = Time.now
    @production_order.net_amount = @fp.net_amount
  end

  def create
    @production_order = ProductionOrder.new(production_order_params)
    @fp = @production_order.formulation_process
    if @production_order.save
      @fp.update_attributes(presentation_assigned_at: Time.now)
      redirect_to production_orders_path, flash: {success: t('.success')}
    else
      add_breadcrumb(t('.title'))
      @production_order.created_at = Time.now
      render :new
    end
  end

  def tags
    breadcrumbs.clear

    if params[:tags] and params[:tags][:batch]
      @fp = FormulationProcess.find_by(batch: params[:tags][:batch])
      redirect_to production_orders_tags_path,
        flash: { warning: t('.batch_not_found',
          batch: params[:tags][:batch])} and return if !@fp
      render 'tags', layout: false and return
    end

    render 'tags_form'
  end

  private
  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(ProductionOrder), production_orders_path)
  end

  def production_order_params
    params.require(:production_order).permit(:product_presentation,
      :packing_type, :total_packages, :baskets, :comment, :net_amount,
      :user_id, :formulation_process_id)
  end
end
