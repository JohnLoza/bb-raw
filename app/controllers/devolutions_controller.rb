class DevolutionsController < ApplicationController
  before_action :reset_breadcrumbs

  def index
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse], or: [User::ROLES[:administration]])

    @devolutions = Devolution.active.recent.search(key_words: search_params, fields: [:hash_id]).page(params[:page])
      .includes(:user, :authorizer)
  end

  def show
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse], or: [User::ROLES[:administration]])
  end

  def new
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse])
    @devolution = Devolution.new(user_id: current_user.id)
    @providers = Provider.active.a_z
  end

  def create
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse])
    @devolution = Devolution.new(devolution_params)
    @devolution.user_id = current_user.id

    stock = Stock.where(product_id: params[:product_id], batch: params[:batch]).take
    redirect_to new_devolution_path, flash: { info: t('.stock_not_found') } and return unless stock

    @devolution.stock_id = stock.id

    if @devolution.save
      redirect_to devolution_path(@devolution), flash: { success: t('.success') }
    else
      render :new
      @providers = Provider.active.a_z
    end
  end

  def destroy
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse])
    devolution = Devolution.find_by!(hash_id: params[:id])
    if devolution.destroy
      flash[:success] = t('.success')
    else
      flash[:info] = t('.failure')
    end
    redirect_to devolutions_path
  end

  def authorize!
    deny_access! and return unless current_user.has_role?(User::ROLES[:administration])
    devolution = Devolution.find_by!(hash_id: params[:id])
    if devolution.authorize!(current_user)
      flash[:success] = t('.success')
    else
      flash[:info] = t('.failure')
    end
    redirect_to devolutions_path
  end

  private
  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(Stock), stocks_path)
    add_breadcrumb(label_for_model(Devolution), devolutions_path)
  end

  def devolution_params
    params.require(:devolution).permit(:bulk, :description)
  end
end
