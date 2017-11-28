class StocksController < ApplicationController
  def index
    set_breadcrumbs(label_for_model(Stock), stocks_path)
    @stocks = Stock.all.search(search_params, :batch)
      .page(params[:page]).includes(product: :provider)
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
end
