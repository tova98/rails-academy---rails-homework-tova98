module Authenticatable
  extend ActiveSupport::Concern

  def authenticate
    return unless request.headers['Authorization'].nil?

    render json: { errors: { token: ['is invalid'] } }, status: :unauthorized
  end
end
