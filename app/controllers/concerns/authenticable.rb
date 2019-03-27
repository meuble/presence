module Authenticable
  extend ActiveSupport::Concern
  include ExceptionHandler
  
  def token
    params[:token] || token_from_request_headers || cookies.signed[:jwt]
  end
  
  def token_from_request_headers
    unless request.headers['Authorization'].nil?
      request.headers['Authorization'].split.last
    end
  end

  def current_user
    @current_user ||= 
      begin
        User.from_auth_token(token) if token
      rescue
        nil
      end
  end
  
  def require_login
    @user = User.from_auth_token(token)
  end
end