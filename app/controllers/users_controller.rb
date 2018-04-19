class UsersController < ApplicationController
  before_action :reset_breadcrumbs
  before_action :load_roles

  def index
    deny_access! and return unless current_user.has_role?(User::ROLES[:human_resources], or: [User::ROLES[:administration]])

    @users = User.non_admin.active.recent
      .search(key_words: search_params, fields: [:name, :email, :hash_id]).page(params[:page])
  end

  def new
    deny_access! and return unless current_user.has_role?(User::ROLES[:human_resources])

    @user = User.new
    add_breadcrumb(t('.title'))
    puts breadcrumbs
  end

  def show
    deny_access! and return unless current_user.has_role?(User::ROLES[:human_resources], or: [User::ROLES[:administration]])

    @user = find_user
    add_breadcrumb(@user)
  end

  def create
    deny_access! and return unless current_user.has_role?(User::ROLES[:human_resources])

    @user = User.new(user_params)
    @user.set_roles(roles_params)

    if @user.save
      @user.avatar.recreate_versions! if @user.avatar.present?
      redirect_to users_path, flash: {success: t('.success', subject: @user)}
    else
      render :new
    end
  end

  def edit
    deny_access! and return unless current_user.has_role?(User::ROLES[:human_resources])

    @user = find_user
    add_breadcrumb(@user, user_path(@user))
    add_breadcrumb(t('.title'))
  end

  def update
    deny_access! and return unless current_user.has_role?(User::ROLES[:human_resources])

    @user = find_user
    set_crop_coordinates

    if @user.update_attributes(user_params)
      @user.set_roles(roles_params)
      redirect_to user_path(@user), flash: {success: t('.success', subject: @user)}
    else
      render :edit
    end
  end

  def destroy
    deny_access! and return unless current_user.has_role?(User::ROLES[:human_resources])

    @user = find_user
    if @user.destroy
      flash[:success] = t('.success')
    else
      flash[:warning] = t('.failure')
    end
    redirect_to users_path
  end

  private
  def reset_breadcrumbs
    set_breadcrumbs(label_for_model(User), users_path)
  end

  def find_user
    user = User.find_by!(hash_id: params[:id])
    # let the admin see and update his own information, others can't #
    deny_access! if user.admin? && !current_user?(user)
    return user
  end

  def user_params
    params.require(:user).permit(
      :email, :name, :address, :phone_number, :username, :avatar,
      :cell_phone_number, :password, :password_confirmation,
      :crop_x, :crop_y, :crop_w, :crop_h
    )
  end

  def roles_params
    params[:user][:roles]
  end

  def load_roles
    @roles = Array.new
    User::ROLES.keys.each do |key|
      @roles << {name: User::ROLES[key], display_name: t("activerecord.attributes.roles.#{User::ROLES[key]}")}
    end
  end

  def set_crop_coordinates
    @user.crop_x = params[:user][:crop_x]
    @user.crop_y = params[:user][:crop_y]
    @user.crop_h = params[:user][:crop_h]
    @user.crop_w = params[:user][:crop_w]
  end
end
