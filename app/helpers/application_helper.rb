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
    when 'bb_entry_reports'.freeze
      'bb_products'.freeze
    when 'bb_stocks'.freeze
      'bb_products'.freeze
    else
      controller_name
    end
  end

  def months_for_select
    months = Array.new
    months << [nil, nil]
    months << [t('date.month_names')[1].capitalize, 'A'.freeze]
    months << [t('date.month_names')[2].capitalize, 'B'.freeze]
    months << [t('date.month_names')[3].capitalize, 'C'.freeze]
    months << [t('date.month_names')[4].capitalize, 'D'.freeze]
    months << [t('date.month_names')[5].capitalize, 'E'.freeze]
    months << [t('date.month_names')[6].capitalize, 'F'.freeze]
    months << [t('date.month_names')[7].capitalize, 'G'.freeze]
    months << [t('date.month_names')[8].capitalize, 'H'.freeze]
    months << [t('date.month_names')[9].capitalize, 'I'.freeze]
    months << [t('date.month_names')[10].capitalize, 'J'.freeze]
    months << [t('date.month_names')[11].capitalize, 'K'.freeze]
    months << [t('date.month_names')[12].capitalize, 'L'.freeze]
  end

  def month(month_key)
    months_for_select.each do |month|
      # month[0] = month name, month[1] = month key
      return month[0] if month[1] == month_key
    end
  end
end
