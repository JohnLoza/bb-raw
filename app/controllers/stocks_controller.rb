class StocksController < ApplicationController
  def index
    set_breadcrumbs(label_for_model(Stock), stocks_path)
    @stocks = Stock.all.search(search_params, :batch)
      .page(params[:page]).includes(product: :provider)
  end
end
