class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to root_path, notice: 'Already signed in : )'
    else
      @user = User.new
    end
  end

  def create
    @user = User.find_by(username: params[:session][:username])
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Signed in successfully!'
    else
      flash.now[:alert] = 'Permission denied.'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Signed out successfully!'
  end
end
