class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include FrontendHelper
  include SessionsHelper

  helper_method :search_params

  before_action :authenticate_user!
  before_action :set_locale

  # rescue_from Exception, with: :method not working somehow
  rescue_from ActiveRecord::RecordNotFound do |e|
    render_404
  end
  rescue_from ActionController::UnknownFormat do |e|
    render_404
  end
  rescue_from ActionController::UnknownController do |e|
    render_404
  end
  rescue_from ActionController::RoutingError do |e|
    render_404
  end

  def index
    # manually raise an exception
    # raise ActiveRecord::RecordNotFound unless condition
    breadcrumbs.clear
  end

  private
  def authenticate_user!
    unless logged_in?
      store_location
      redirect_to log_in_path
    end
  end

  def deny_access!
    respond_to do |format|
      format.html { redirect_to root_path, flash: {info: t(:access_denied)} }
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
