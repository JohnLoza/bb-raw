class CategoriesController < ApplicationController
  before_action :reset_breadcrumbs
  helper_method :parent_param

  def index
    if parent_param.present?
      @pc = find_category(parent_param)
      @categories = @pc.subcategories.active.a_z
        .search(search_params, :name, :hash_id).page(params[:page])
      set_breadcrumbs_tree(@pc)
      @header_title = t('.sub_categories_title', category: @pc)
    else
      @categories = Category.active.main_categories.a_z
        .search(search_params, :name, :hash_id).page(params[:page])
      @header_title = t('.title')
    end

    respond_to do |format|
      format.html{ render :index }
      format.json{ render json: @categories.to_json, status: 200 }
    end
  end

  def show
    @category = find_category
    set_breadcrumbs_tree(@category)
  end

  def new
    @category = Category.new
    set_breadcrumbs_tree(find_category(parent_param)) if parent_param
    add_breadcrumb(t('.title'))
  end

  def create
    if parent_param.present?
      @category = find_category(parent_param)
      @category.subcategories << Category.new(category_params)
    else
      @category = Category.new(category_params)
    end

    if @category.save
      redirect_to categories_or_subcategories, flash: {success: t('.success', subject: @category)}
    else
      render :new
    end
  end

  def edit
    @category = find_category
    set_breadcrumbs_tree(@category)
    add_breadcrumb(t('.title'))
  end

  def update
    @category = find_category
    if @category.update_attributes(category_params)
      redirect_to categories_or_subcategories, flash: {success: t('.success', subject: @category)}
    else
      render :edit
    end
  end

  def destroy
    @category = find_category
    if @category.destroy
      flash[:success] = t('.success')
    else
      flash[:info] = t('.failure')
    end
    redirect_to categories_or_subcategories
  end

  private
  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(Category), categories_path)
  end

  def find_category(hash_id = nil)
    hash_id = params[:id] unless hash_id.present?
    Category.find_by!(hash_id: hash_id)
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def set_breadcrumbs_tree(category) # category = Category
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
      add_breadcrumb(i[:name], categories_path(parent: i[:hash_id]))
    end
  end

  def parent_param
    params[:parent]
  end

  def categories_or_subcategories
    return categories_path unless parent_param.present?
    categories_path(parent: parent_param)
  end
end
