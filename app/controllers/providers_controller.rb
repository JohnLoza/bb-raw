class ProvidersController < ApplicationController

  def index
    @providers = Provider.active.recent
      .search(search_params, :name, :hash_id).page(params[:page])
  end

  def show
    @provider = find_provider
  end

  def new
    @provider = Provider.new
  end

  def create
    @provider = Provider.new(provider_params)

    if @provider.save
      redirect_to providers_path, flash: {success: t('.success', subject: @provider.name)}
    else
      render :new
    end
  end

  def edit
    @provider = find_provider
  end

  def update
    @provider = find_provider
    if @provider.update_attributes(provider_params)
      redirect_to providers_path, flash: {success: t('.success', subject: @provider.name)}
    else
      render :edit
    end
  end

  def destroy
    @provider = find_provider
    if @provider.mark_as_deleted!
      flash[:success] = t('.success')
    else
      flash[:warning] = t('.failure')
    end
    redirect_to providers_path
  end

  private
    def provider_params
      params.require(:provider).permit(:name, :address, :phone_number, :contact)
    end

    def find_provider
      Provider.find_by!(hash_id: params[:id])
    end
end
