class BbStocksController < ApplicationController
  before_action :reset_breadcrumbs

  def index
    @stocks = BbStock.all.search(key_words: search_params, fields: [:batch]).recent.depleted(params[:depleted])
      .page(params[:page]).per(100).includes(:bb_product)
  end

  private
    def reset_breadcrumbs
      set_breadcrumbs(label_for_model(Stock), stocks_path)
      add_breadcrumb(label_for_model(BbProduct), bb_products_path)
    end
end
