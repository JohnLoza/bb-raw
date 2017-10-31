class SessionsController < ApplicationController
  skip_before_action :logged_in_user

  def new
    if logged_in?
      redirect_to root_path and return
    end

    render :new, layout: false
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or root_path
    else
      flash.now[:info] = t('.wrong_user_password')
      @email = params[:session][:email].downcase
      render :new, layout: false
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to log_in_path and return
  end
end
