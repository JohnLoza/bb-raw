class BbProductsController < ApplicationController
  before_action :reset_breadcrumbs

  def index
    @bb_products = BbProduct.active.a_z
      .search(search_params, :name, :hash_id).page(params[:page])
  end

  def show
    @bb_product = find_bb_product
    add_breadcrumb(@bb_product)
  end

  def new
    @bb_product = BbProduct.new
    add_breadcrumb(t(:new))
  end

  def create
    @bb_product = BbProduct.new(bb_product_params)
    if @bb_product.save
      flash[:success] = t('.success', subject: @bb_product)
      redirect_to bb_products_path
    else
      flash.now[:warning] = t('.failure')
      render :new
    end
  end

  def edit
    @bb_product = find_bb_product
    add_breadcrumb(@bb_product, bb_product_path(@bb_product))
    add_breadcrumb(t(:edit))
  end

  def update
    @bb_product = find_bb_product
    if @bb_product.update_attributes(bb_product_params)
      flash[:success] = t('.success', subject: @bb_product)
      redirect_to bb_product_path(@bb_product)
    else
      render edit
    end
  end

  def destroy
    @product = find_product
    if @product.destroy
      flash[:success] = t('.success')
    else
      flash[:warning] = t('.failure')
    end

    redirect_to bb_products_path
  end

  private
  def find_bb_product
    BbProduct.find_by!(hash_id: params[:id])
  end

  def bb_product_params
    params.require(:bb_product).permit(:name, :presentation)
  end

  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(BbProduct), bb_products_path)
  end
end
