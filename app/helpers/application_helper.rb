module ApplicationHelper
  # Parse the controller_name into one of the ids for the menu items #
  # so we can add 'active class' to that menú item #
  def controller_menu_id(controller_name)
    case controller_name
    when 'application'.freeze
      'home'.freeze
    when 'products'.freeze
      'providers'.freeze
    when 'supplies'.freeze
      'development_orders'.freeze
    else
      controller_name
    end
  end
end
