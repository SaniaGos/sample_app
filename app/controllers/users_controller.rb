class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :show, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  WillPaginate.per_page = 10

  def index
    # debugger
    @users = User.order("admin DESC").paginate(page: params[:page])
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save # Обработать успешное сохранение.
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to(@user)  # те саме redirect_to user_url(@user)
    else
      render "new"
    end
  end

  def edit
    # @user = User.find(params[:id])
  end

  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Профіль обновлено"
      redirect_to(@user)
    else
      render "edit"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # Подтверждает вход пользователя.
  def logged_in_user
    # debugger
    unless logged_in?
      store_location               # зберігаєм запрошувальну сторінку
      flash[:danger] = "Будь ласка увійдіть"
      redirect_to(login_url)
    end
  end

  # Подтверждает права пользователя.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
