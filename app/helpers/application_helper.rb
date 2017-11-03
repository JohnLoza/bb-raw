module ApplicationHelper
  # Parse the controller_name into one of the ids for the menu items #
  # so we can add 'active class' to that menú item #
  def controller_menu_id(controller_name)
    case controller_name
    when 'application'
      'home'
    else
      controller_name
    end
  end

  # Build the label for search box #
  def search_by_label(class_instance, *attributes)
    args = []
    attributes.each do |a|
      args << class_instance.human_attribute_name(a)
    end
    t(:search_by, args: args.join(Utils::SPLITTER))
  end

  # product_categories breadcrumbs
  def product_categories_breadcrumbs(category)
    breadcrumbs = Array.new
    loop do
      breadcrumbs << (link_to category.name, product_categories_path(category_id: category))
      if category.has_parent?
        category = category.parent_category
      else
        break
      end
    end

    return breadcrumbs
  end
end
