module Authorizable
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError, with: :authorization_error
    include Pundit
  end

  def authorization_error
    render json: { errors: { resource: ['is forbidden'] } }, status: :forbidden
  end
end
