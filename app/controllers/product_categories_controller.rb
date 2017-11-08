class ProductCategoriesController < ApplicationController
  before_action :reset_breadcrumbs
  helper_method :parent_param

  def index
    if parent_param.present?
      @pc = find_category(parent_param)
      @product_categories = @pc.subcategories.active.a_z
        .search(search_params, :name, :hash_id).page(params[:page])
      set_breadcrumbs_tree(@pc)
      @header_title = t('.sub_categories_title', category: @pc)
    else
      @product_categories = ProductCategory.main_categories.active.a_z
        .search(search_params, :name, :hash_id).page(params[:page])
      @header_title = t('.title')
    end

    respond_to do |format|
      format.html{ render :index }
      format.json{ render json: @product_categories.to_json, status: 200 }
    end
  end

  def show
    @product_category = find_category
    set_breadcrumbs_tree(@product_category)
  end

  def new
    @product_category = ProductCategory.new
    set_breadcrumbs_tree(find_category(parent_param)) if parent_param
    add_breadcrumb(t('.title'))
  end

  def create
    if parent_param.present?
      @product_category = find_category(parent_param)
      @product_category.subcategories << ProductCategory.new(product_category_params)
    else
      @product_category = ProductCategory.new(product_category_params)
    end

    if @product_category.save
      redirect_to categories_or_subcategories, flash: {success: t('.success', subject: @product_category)}
    else
      render :new
    end
  end

  def edit
    @product_category = find_category
    set_breadcrumbs_tree(@product_category)
    add_breadcrumb(t('.title'))
  end

  def update
    @product_category = find_category
    if @product_category.update_attributes(product_category_params)
      redirect_to categories_or_subcategories, flash: {success: t('.success', subject: @product_category)}
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
  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(ProductCategory), product_categories_path)
  end

  def find_category(hash_id = nil)
    hash_id = params[:id] unless hash_id.present?
    ProductCategory.find_by!(hash_id: hash_id)
  end

  def product_category_params
    params.require(:product_category).permit(:name)
  end

  def set_breadcrumbs_tree(category) # category = ProductCategory
    items = Array.new
    loop do
      items.push({name: category, hash_id: category.hash_id})
      if category.has_parent?
        category = category.parent_category
      else
        break
      end
    end

    items.reverse.each do |i|
      add_breadcrumb(i[:name], product_categories_path(parent: i[:hash_id]))
    end
  end

  def parent_param
    params[:parent]
  end

  def categories_or_subcategories
    return product_categories_path unless parent_param.present?
    product_categories_path(parent: parent_param)
  end
end
