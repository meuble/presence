class User < ApplicationRecord  
  has_secure_password

  validates_presence_of :name, :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  
  has_many :lines
  
  def auth_token
    payload = {user_id: self.id, exp: 1.hour.from_now.to_i }
    hmac_secret = Rails.application.credentials.secret_key_base
    JWT.encode payload, hmac_secret, 'HS256'
  end

  def self.from_auth_token(token)
    payload = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' }).first
    User.find(payload["user_id"].to_i)
  end
end
