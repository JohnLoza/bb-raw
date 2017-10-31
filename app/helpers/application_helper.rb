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
end
