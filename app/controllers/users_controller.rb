class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    unless @user = User.find_by(id: params[:id])
      render(text: "<h1>User not found</h1>", status: 404)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save # Обработать успешное сохранение.
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to(@user)  # те саме redirect_touser_url(@user)
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Профіль оновлено"
      redirect_to @user
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
