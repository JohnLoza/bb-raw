class ProductCategoriesController < ApplicationController
  before_action :load_product_category, only: [:show, :edit, :update, :destroy]

  def index
    if params[:category] && search_params
      @product_categories = ProductCategory.search_by_sql(search_params).a_z.page(params[:page])
    elsif params[:category_id].present?
      load_product_category(params[:category_id])
      @product_categories = @product_category.subcategories.active.a_z.page(params[:page])
    else
      @product_categories = ProductCategory.main_categories.active.a_z.page(params[:page])
    end
  end

  def show

  end

  def new
    @product_category = ProductCategory.new
  end

  def create
    if params[:category] && params[:category][:id].present?
      # create a subcategory
      load_product_category(params[:category][:id])
      @product_category.subcategories << ProductCategory.new(product_category_params)
    else
      @product_category = ProductCategory.new(product_category_params)
    end

    if @product_category.save
      flash[:success] = t('.success', subject: @product_category.name, id: @product_category.hash_id)
      redirect_to categories_or_subcategories
    else
      flash[:info] = t('.failure')
      render :new
    end
  end

  def edit

  end

  def update
    if @product_category.update_attributes(product_category_params)
      flash[:success] = t('.success', subject: @product_category.name)
      redirect_to categories_or_subcategories
    else
      flash[:info] = t('.failure', subject: @product_category.name)
      render :edit
    end
  end

  def destroy
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

    def search_params
      params[:category][:search]
    end

    def load_product_category(hash_id = nil)
      hash_id = params[:id] unless hash_id.present?
      @product_category = ProductCategory.find_by(hash_id: hash_id)
      raise ActiveRecord::RecordNotFound unless @product_category
    end

    def categories_or_subcategories
      return product_categories_path unless params[:category] && params[:category][:id].present?
      product_categories_path(category_id: params[:category][:id])
    end
end
