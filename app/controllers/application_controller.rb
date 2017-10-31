class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :logged_in_user
  before_action :load_current_user
  include SessionsHelper

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index

  end

  private
    # Set locale to spanish #
    def set_locale
      I18n.locale = :es
    end

    def load_current_user
      current_user
    end

    def logged_in_user
      unless logged_in?
        store_location
        redirect_to log_in_path and return
      end
    end

    def render_404
      render file: "#{Rails.root}/public/404.html.erb", status: 404
    end
end
