class ProductsController < ApplicationController
  before_action :load_provider, except: :all_products
  before_action :reset_breadcrumbs, except: :all_products

  def index
    @products = @provider.products.active.a_z
      .search(search_params, :name, :hash_id).page(params[:page])

    respond_to do |format|
      format.html{ render :index }
      format.json{ render json: @products, status: 200 }
    end
  end

  def show
    @product = find_product
    add_breadcrumb(@product)
  end

  def new
    @product = Product.new
    add_breadcrumb(t(:new))
  end

  def create
    @product = @provider.products.build(product_params)
    if @product.save
      flash[:success] = t('.success', subject: @product)
      redirect_to provider_products_path(@provider)
    else
      flash.now[:warning] = t('.failure')
      render :new
    end
  end

  def edit
    @product = find_product
    add_breadcrumb(@product, provider_product_path(@provider, @product))
    add_breadcrumb(t(:edit))
  end

  def update
    @product = find_product
    if @product.update_attributes(product_params)
      flash[:success] = t('.success', subject: @product)
      redirect_to provider_product_path(@provider, @product)
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

    redirect_to provider_products_path(@provider)
  end

  def all_products
    @products = Product.select(:name).search(search_params, :name).limit(15).distinct

    respond_to do |format|
      format.json{ render json: @products.as_json(only: :name), status: 200 }
      format.any{ head :not_found }
    end
  end

  private
  def load_provider
    @provider = Provider.find_by!(hash_id: params[:provider_id])
  end

  def find_product
    @provider.products.find_by!(hash_id: params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :presentation)
  end

  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(Provider), providers_path)
    add_breadcrumb(@provider, provider_path(@provider))
    add_breadcrumb(
      label_for_model(Product),
      provider_products_path(params[:provider_id])
    )
  end
end
