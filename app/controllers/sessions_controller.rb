class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # enter user and redirect_to user page
      log_in(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to(user)
    else
      # create error message and return login page
      flash.now[:danger] = "Invalid email/password combination" # error message
      render("new")
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end