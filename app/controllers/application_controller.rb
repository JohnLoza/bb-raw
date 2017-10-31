class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :logged_in_user
  before_action :load_current_user
  include SessionsHelper

  def index

  end

  private
    # Set locale to spanish #
    def set_locale
      I18n.locale = :es
    end
end
