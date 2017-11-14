module FrontendHelper
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    Time.zone = 'Guadalajara'
  end

  def set_breadcrumbs(label = nil, target = nil)
    breadcrumbs.clear
    return unless label.present?
    breadcrumbs.push(Breadcrumb.new(label, target))
  end

  def add_breadcrumb(label, target = nil)
    return unless label.present?
    bc = Breadcrumb.new(label, target) # BreadCrumb
    breadcrumbs.push(bc)
  end

  def breadcrumbs
    session[:breadcrumbs] ||= Array.new
  end

  def label_for_model(model)
    model.model_name.human(count: 2)
  end
end
