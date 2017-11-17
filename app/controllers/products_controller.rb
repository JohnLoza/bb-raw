class ProductsController < ApplicationController
  before_action :load_provider
  before_action :reset_breadcrumbs

  def index
    @products = @provider.products.active.recent
      .search(search_params, :name, :hash_id).page(params[:page])
      .includes(:category)

    respond_to do |format|
      format.html{ render :index }
      format.json{ render json: @products, status: 200 }
    end
  end

  def show
    @product = find_product
    load_categories
    add_breadcrumb(@product)
  end

  def new
    @product = Product.new
    load_categories
    add_breadcrumb(t(:new))
  end

  def create
    @product = @provider.products.build(product_params)
    if @product.save
      flash[:success] = t('.success', subject: @product)
      redirect_to provider_products_path(@provider)
    else
      load_categories
      flash.now[:warning] = t('.failure')
      render :new
    end
  end

  def edit
    @product = find_product
    load_categories
    add_breadcrumb(@product)
  end

  def update
    @product = find_product
    if @product.update_attributes(product_params)
      redirect_to provider_product_path(@provider, @product)
    else
      load_categories
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

  private
  def load_provider
    @provider = Provider.find_by!(hash_id: params[:provider_id])
  end

  def load_categories
    @categories = Category.active.main_categories.a_z
    return unless @product.persisted?
    main_category = @product.category.parent_category
    @subcategories = main_category.subcategories
    @main_selected = main_category.hash_id
  end

  def find_product
    @provider.products.find_by(hash_id: params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :presentation, :category_id)
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
