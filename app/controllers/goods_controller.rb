class GoodsController < ApplicationController
  before_action :reset_breadcrumbs
  before_action :verify_current_user_authority, except: [:use, :retrieve]

  def index
    @goods = Good.active.recent
      .search(key_words: search_params, fields: [:name, :hash_id])
      .page(params[:page]).includes(:last_used_by_user)
  end

  def show
    @good = find_good
    @registries = @good.registries.recent.limit(100).includes(:user)
    add_breadcrumb(@good)
  end

  def new
    @good = Good.new
    add_breadcrumb(t('.title'))
  end

  def create
    @good = Good.new(good_params)

    if @good.save
      redirect_to goods_path, flash: { success: t('.success') }
    else
      render :new
    end
  end

  def edit
    @good = find_good
    add_breadcrumb(@good, good_path(@good))
    add_breadcrumb(t('.title'))
  end

  def update
    @good = find_good

    if @good.update_attributes(good_params)
      redirect_to good_path(@good), flash: { success: t('.success') }
    else
      render :edit
    end
  end

  def destroy
    @good = find_good

    if @good.destroy
      flash[:success] = t('.success')
    else
      flash[:warning] = t('.failure')
    end
    redirect_to goods_path
  end

  def use
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse])
    good = find_good
    redirect_to root_path, flash: { info: t('.good_in_use', good: good) } and return unless good.last_used_at.nil?

    ActiveRecord::Base.transaction do
      good.update_attributes(last_used_by: current_user.id, last_used_at: Time.now)
      GoodRegistry.create(good_id: good.id, user_id: current_user.id, descriptor: GoodRegistry::USE)
    end
    redirect_to root_path, flash: { success: t('.success') }
  end

  def retrieve
    deny_access! and return unless current_user.has_role?(User::ROLES[:warehouse])
    good = find_good

    redirect_to root_path, flash: { info: t('.good_not_in_use', good: good) } and return unless good.last_used_at.present?
    redirect_to root_path, flash: { info: t('.not_the_right_person', person: good.last_used_by_user) } and return unless good.last_used_by == current_user.id

    ActiveRecord::Base.transaction do
      good.update_attributes(last_used_by: nil, last_used_at: nil)
      GoodRegistry.create(good_id: good.id, user_id: current_user.id, descriptor: GoodRegistry::RETRIEVE)
    end

    redirect_to root_path, flash: { success: t('.success') }
  end

  def qr_codes
    require 'rqrcode'

    @good = find_good
    @qr_for_use = RQRCode::QRCode.new(use_good_url @good)
    @qr_for_retrieve = RQRCode::QRCode.new(retrieve_good_url @good)

    # render :qr_codes, layout: false
    respond_to do |format|
      format.any { render_404 }
      format.pdf do
        render pdf: "qr_codes_for_good_#{@good}"
      end
    end
  end

  private
  def verify_current_user_authority
    deny_access! and return unless current_user.has_role?(User::ROLES[:goods])
  end

  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(Good), goods_path)
  end

  def find_good
    Good.find_by!(hash_id: params[:id])
  end

  def good_params
    params.require(:good).permit(:name)
  end
end
