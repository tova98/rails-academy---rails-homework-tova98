module RecordNotFoundRescue
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_from_not_found
  end

  def rescue_from_not_found
    render json: { errors: ["#{controller_name.classify} not found."] }, status: :bad_request
  end
end
