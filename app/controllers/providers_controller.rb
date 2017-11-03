class ProvidersController < ApplicationController
  before_action :load_provider, only: [:show, :edit, :update, :destroy]

  def index
    if params[:provider] && search_params
      @providers = Provider.search_by_sql(search_params).recent.page(params[:page])
    else
      @providers = Provider.active.recent.page(params[:page])
    end
  end

  def show

  end

  def new
    @provider = Provider.new
  end

  def create
    @provider = Provider.new(provider_params)

    if @provider.save
      flash[:success] = t('.success', subject: @provider.name, id: @provider.hash_id)
      redirect_to providers_path
    else
      flash[:info] = t('.failure')
      render :new
    end
  end

  def edit

  end

  def update
    if @provider.update_attributes(provider_params)
      flash[:success] = t('.success', subject: @provider.name)
      redirect_to providers_path
    else
      flash[:info] = t('.failure', subject: @provider.name)
      render :edit
    end
  end

  def destroy
    if @provider.mark_as_deleted!
      flash[:success] = t('.success')
    else
      flash[:info] = t('.failure')
    end
    redirect_to providers_path
  end

  private
    def provider_params
      params.require(:provider).permit(:name, :address, :phone_number, :contact)
    end

    def search_params
      params[:provider][:search]
    end

    def load_provider
      @provider = Provider.find_by(hash_id: params[:id])
      raise ActiveRecord::RecordNotFound unless @provider
    end
end
