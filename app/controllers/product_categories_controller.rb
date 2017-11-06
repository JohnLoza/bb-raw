class ProductCategoriesController < ApplicationController
  helper_method :parent_category_id

  def index
    if parent_category_id.present?
      @product_category = find_category(parent_category_id)
      @product_categories = @product_category.subcategories.active.a_z
        .search(search_params, :name, :hash_id).page(params[:page]).includes(:parent_category)
    else
      @product_categories = ProductCategory.main_categories.active.a_z
        .search(search_params, :name, :hash_id).page(params[:page])
    end
  end

  def show
    @product_category = find_category
  end

  def new
    @product_category = ProductCategory.new
  end

  def create
    if parent_category_id.present?
      @product_category = find_category(parent_category_id)
      @product_category.subcategories << ProductCategory.new(product_category_params)
    else
      @product_category = ProductCategory.new(product_category_params)
    end

    if @product_category.save
      redirect_to categories_or_subcategories, flash: {success: t('.success', subject: @product_category.name)}
    else
      render :new
    end
  end

  def edit
    @product_category = find_category
  end

  def update
    @product_category = find_category
    if @product_category.update_attributes(product_category_params)
      redirect_to categories_or_subcategories, flash: {success: t('.success', subject: @product_category.name)}
    else
      render :edit
    end
  end

  def destroy
    @product_category = find_category
    if @product_category.mark_as_deleted!
      flash[:success] = t('.success')
    else
      flash[:info] = t('.failure')
    end
    redirect_to categories_or_subcategories
  end

  private
    def product_category_params
      params.require(:product_category).permit(:name)
    end

    def parent_category_id
      return nil unless params[:category]
      params[:category][:id]
    end

    def search_params
      return nil unless params[:category]
      params[:category][:search]
    end

    def find_category(hash_id = nil)
      hash_id = params[:id] unless hash_id.present?
      ProductCategory.find_by!(hash_id: hash_id)
    end

    def categories_or_subcategories
      return product_categories_path unless parent_category_id.present?
      product_categories_path(category: {id: parent_category_id})
    end
end
