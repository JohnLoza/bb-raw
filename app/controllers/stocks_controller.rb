class StocksController < ApplicationController
  before_action :reset_breadcrumbs

  def index
    @stocks = Stock.all.search(search_params, :batch).recent.depleted(params[:depleted])
      .page(params[:page]).per(100).includes(product: :provider)
  end

  def by_provider
    provider = Provider.find_by!(hash_id: params[:provider_id])
    stocks = Stock.by_provider(provider).includes(:product)

    respond_to do |format|
      format.json{ render json: stocks.as_json(
          only: [:id, :batch],
          include: {product: {only: [:name, :presentation]}}
        ),
        status: 200
      }
      format.any{ head :not_found }
    end
  end

  def track
    add_breadcrumb(t('.title'))
    @providers = Provider.all unless params[:provider]

    if params[:provider]
      @stock = Stock.find_by(product_id: params[:product], batch: params[:batch])
      unless @stock
        redirect_to tracking_stocks_path, flash: { warning: t('.not_found')} and return
      end
      @product = @stock.product
      @provider = @product.provider
      @supplies = Supply.where(stock_id: @stock.id).includes(:order)
    end

    respond_to do |format|
      format.html
      format.pdf{ render pdf: "tracking_#{Time.now}" }
    end
  end

  private
    def reset_breadcrumbs
      set_breadcrumbs(label_for_model(Stock), stocks_path)
    end
end
