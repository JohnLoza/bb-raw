class UsersController < ApplicationController
  before_action :load_roles, only: [:new, :create, :edit, :update, :show]
  before_action :load_user, only: [:show, :edit, :update, :destroy]

  def index
    if params[:user] && search_params
      @users = User.search_by_sql(search_params).recent.page(params[:page])
    else
      @users = User.non_admin.active.recent.page(params[:page])
    end
  end

  def new
    @user = User.new
  end

  def show

  end

  def create
    @user = User.new(user_params)
    @user.roles = params[:user][:roles].join(Utils::SPLITTER) if params[:user][:roles]

    if @user.save
      @user.avatar.recreate_versions!
      flash[:success] = t('.success', subject: @user.username, id: @user.hash_id)
      redirect_to users_path
    else
      flash[:info] = t('.failure')
      render :new
    end
  end

  def edit

  end

  def update
    load_crop_coordinates

    if @user.update_attributes(user_params)
      @user.update_attribute(:roles, params[:user][:roles].join(Utils::SPLITTER)) if params[:user][:roles]
      flash[:success] = t('.success', subject: @user.username)
      redirect_to users_path
    else
      flash[:info] = t('.failure', subject: @user.username)
      render :edit
    end
  end

  def destroy
    if @user.mark_as_deleted!
      flash[:success] = t('.success')
    else
      flash[:info] = t('.failure')
    end
    redirect_to users_path
  end

  private
    def user_params
      params.require(:user).permit(
        :email, :name, :address, :phone_number, :username, :avatar,
        :cell_phone_number, :password, :password_confirmation,
        :crop_x, :crop_y, :crop_w, :crop_h
      )
    end

    def search_params
      params[:user][:search]
    end

    def load_roles
      @roles = Array.new
      UserRole.available_roles.each do |role|
        @roles << {name: role.to_s, display_name: t("activerecord.attributes.roles.#{role}")}
      end
    end

    def load_user
      @user = User.find_by(hash_id: params[:id])
      raise ActiveRecord::RecordNotFound unless @user
      # only let the admin see and update his own information, others can not #
      raise ActiveRecord::RecordNotFound if @user.admin? && !current_user?(@user)
    end

    def load_crop_coordinates
      @user.crop_x = params[:user][:crop_x]
      @user.crop_y = params[:user][:crop_y]
      @user.crop_h = params[:user][:crop_h]
      @user.crop_w = params[:user][:crop_w]
    end
end
