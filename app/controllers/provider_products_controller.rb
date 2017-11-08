class ProviderProductsController < ApplicationController
  before_action :load_provider
  before_action :reset_breadcrumbs

  def index
    @provider_products = @provider.products.active.recent
      .search(search_params, :name, :hash_id).page(params[:page])
      .includes(:product_category)
  end

  def show
    @provider_product = find_provider_product
    load_categories
    add_breadcrumb(@provider_product)
  end

  def new
    @provider_product = ProviderProduct.new
    load_categories
  end

  def create
    @provider_product = @provider.products.build(provider_product_params)
    if @provider_product.save
      flash[:success] = t('.success', subject: @provider_product)
      redirect_to provider_products_path(@provider)
    else
      load_categories
      flash.now[:warning] = t('.failure')
      render :new
    end
  end

  def edit
    @provider_product = find_provider_product
    load_categories
    add_breadcrumb(@provider_product)
  end

  def update
    @provider_product = find_provider_product
    if @provider_product.update_attributes(provider_product_params)
      redirect_to provider_product_path(@provider, @provider_product)
    else
      load_categories
      render edit
    end
  end

  def destroy
    @provider_product = find_provider_product
    if @provider_product.mark_as_deleted!
      flash[:success] = t('.success')
    else
      flash[:warning] = t('.failure')
    end

    redirect_to provider_products_path(@provider)
  end

  private
  def load_provider
    @provider = Provider.find_by!(hash_id: params[:provider_id])
  end

  def load_categories
    @categories = ProductCategory.main_categories.active.a_z
  end

  def find_provider_product
    @provider.products.find_by(hash_id: params[:id])
  end

  def provider_product_params
    params.require(:provider_product).permit(:name, :presentation, :product_category_id)
  end

  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(Provider), providers_path)
    add_breadcrumb(@provider, provider_path(@provider))
    add_breadcrumb(
      label_for_model(ProviderProduct),
      provider_products_path(params[:provider_id])
    )
  end
end
