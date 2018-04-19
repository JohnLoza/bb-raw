class BbStocksController < ApplicationController
  before_action :verify_current_user_authority
  before_action :reset_breadcrumbs

  def index
    @stocks = BbStock.all.search(key_words: search_params, fields: [:batch]).recent.depleted(params[:depleted])
      .page(params[:page]).per(100).includes(:bb_product)
  end

  private
  def verify_current_user_authority
    deny_access! unless current_user.has_role?(User::ROLES[:warehouse], or: [User::ROLES[:administration]])
  end

  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(Stock), stocks_path)
    add_breadcrumb(label_for_model(BbProduct), bb_products_path)
  end
end
