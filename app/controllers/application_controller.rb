class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :authenticate_user!
  include SessionsHelper

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::UnknownFormat, with: :render_404
  rescue_from ActionController::UnknownController, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  def index
    # manually raise an exception
    # raise ActiveRecord::RecordNotFound unless condition
  end

  private
  # Set locale to spanish #
  def set_locale
    I18n.locale = :es
  end

  def authenticate_user!
    unless logged_in?
      store_location
      redirect_to log_in_path
    end
  end

  def access_denied!
    respond_to do |format|
      format.html { render file: Rails.root.join("public", "404"), layout: false, status: 404 }
      format.any { head :not_found }
    end
  end

  def render_404
    respond_to do |format|
      format.html { render file: Rails.root.join("public", "404"), layout: false, status: 404 }
      format.any { head :not_found }
    end
  end

  def search_params
    return nil unless params[:class]
    params[:class][:search]
  end
end
