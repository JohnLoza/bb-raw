class ProvidersController < ApplicationController
  before_action :reset_breadcrumbs

  def index
    @providers = Provider.active.a_z
      .search(key_words: search_params, fields: [:name, :hash_id, :address]).page(params[:page])
  end

  def show
    @provider = find_provider
    add_breadcrumb(@provider)
  end

  def new
    @provider = Provider.new
    add_breadcrumb(t('.title'))
  end

  def create
    @provider = Provider.new(provider_params)

    if @provider.save
      redirect_to providers_path, flash: {success: t('.success', subject: @provider)}
    else
      render :new
    end
  end

  def edit
    @provider = find_provider
    add_breadcrumb(@provider, provider_path(@provider))
    add_breadcrumb(t('.title'))
  end

  def update
    @provider = find_provider
    if @provider.update_attributes(provider_params)
      redirect_to providers_path, flash: {success: t('.success', subject: @provider)}
    else
      render :edit
    end
  end

  def destroy
    @provider = find_provider
    if @provider.destroy
      flash[:success] = t('.success')
    else
      flash[:warning] = t('.failure')
    end
    redirect_to providers_path
  end

  private
  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(Provider), providers_path)
  end

  def find_provider
    Provider.find_by!(hash_id: params[:id])
  end

  def provider_params
    params.require(:provider).permit(:name, :address, :phone_number, :contact)
  end
end
