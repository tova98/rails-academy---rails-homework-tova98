module RecordNotFoundRescue
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_from_not_found
  end

  def rescue_from_not_found
    if self.class.to_s.split('::').first == 'Admin'
      flash[:danger] = "#{controller_name.classify} not found."
      redirect_to action: 'index'
    else
      render json: { errors: ["#{controller_name.classify} not found."] }, status: :bad_request
    end
  end
end
