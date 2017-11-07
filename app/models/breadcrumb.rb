class Breadcrumb
  attr_accessor :label, :target

  def initialize(label, target)
    self.label = label
    self.target = target
  end

  def to_html
    "<a href=\"#{target}\" class=\"breadcrumb\">#{label}</a> / ".html_safe
  end
end
