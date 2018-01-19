class FormulationProcessesController < ApplicationController
  before_action :load_development_order
  before_action :reset_breadcrumbs

  def index
    @formulation_processes = @order.formulation_processes
  end

  def new
    add_breadcrumb(t('.title'))
    @formulation_process = @order.formulation_processes.new
  end

  def create
    deny_access! unless @order.user_id == current_user.id
    @formulation_process = @order.formulation_processes.build(formulation_process_params)

    if @formulation_process.save
      flash[:success] = t('.success')
      redirect_to my_authorized_development_orders_path
    else
      render :new
    end
  end

  def show
    add_breadcrumb(params[:id])
    @formulation_process = @order.formulation_processes.find_by!(hash_id: params[:id])

    respond_to do |format|
      format.any { render_404 }
      format.pdf do
        render pdf: "formulation_process_#{@formulation_process.hash_id}"
      end
    end
  end

  private
  def load_development_order
    @order = DevelopmentOrder.find_by!(hash_id: params[:development_order_id])
  end

  def formulation_process_params
    params.require(:formulation_process).permit(:product_name, :batch, :net_amount,
      :number_of_cuvettes, :prorated_expiration_date, :gustatory_expiration_date,
      :microbial_expiration_date, :product_life, :equipment_used, :homogeneization_time,
      :total_formulation_time, :user_id, :temperature, :comment)
  end

  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(DevelopmentOrder), development_orders_path)
    add_breadcrumb(@order, development_order_path(@order))
    add_breadcrumb(label_for_model(FormulationProcess), development_order_formulation_processes_path(@order))
  end
end
