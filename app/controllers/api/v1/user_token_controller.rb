class Api::V1::UserTokenController < ApplicationController
  def create
    @user = User.where(email: auth_params[:email]).first
    head(:not_found) and return if @user.nil?

    if @user.authenticate(auth_params[:password])
      cookies.signed[:jwt] = {value:  @user.auth_token, expires: 1.hour.from_now, httponly: true}
      head :created
    else
      head :unauthorized
    end
  end

private
  def auth_params
    params.permit(:email, :password)
  end
end
