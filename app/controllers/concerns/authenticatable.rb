module Authenticatable
  extend ActiveSupport::Concern

  def authenticate
    return if current_user.present?

    render json: { errors: { token: ['is invalid'] } }, status: :unauthorized
  end
end
