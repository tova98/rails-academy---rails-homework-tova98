class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authenticate

  def current_user
    return if request.headers['Authorization'].blank?

    @current_user ||= User.find_by(token: request.headers['Authorization'])
  end

  include Authenticatable
  include Authorizable
  include RecordNotFoundRescue
  include RenderWithSerializer
  include RenderWithRoot
end
