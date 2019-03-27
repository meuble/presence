module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError do |e|
      render json: { type: e.class.name, message: e.message }, status: :internal_server_error
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { type: e.class.name, message: e.message }, status: :unprocessable_entity
    end
    
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { type: e.class.name, message: e.message }, status: :not_found
    end
    
    rescue_from JWT::DecodeError do |e|
      render json: { type: e.class.name, message: e.message }, status: :unauthorized
    end
    
    rescue_from JWT::ExpiredSignature do |e|
      render json: { type: e.class.name, message: e.message }, status: :unauthorized
    end
  end
end