class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  # WillPaginate.per_page = 10

  def index
    # debugger
    @users = User.where(activated: true).order("admin DESC").paginate(page: params[:page])
  end

  def show
    @user = User.find_by(id: params[:id])
    @microposts = @user.microposts.paginate(page: params[:page]).per_page(15)
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save # Обработать успешное сохранение.
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "new"
    end
  end

  def edit
    # @user = User.find(params[:id])
  end

  def update
    # debugger
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

  def following
    # debugger
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page]).per_page(15)
    render "show_follow"
  end

  def followers
    # debugger
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page]).per_page(15)
    render "show_follow"
  end

  private

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # Подтверждает права пользователя.
  def correct_user
    # debugger
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # def correct_user_or_admin
  #   @user = User.find(params[:id])
  #   redirect_to(root_url) unless current_user?(@user) || @user.admin?
  # end
end
