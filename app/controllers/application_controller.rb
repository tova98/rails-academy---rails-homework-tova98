class ApplicationController < ActionController::Base
  include Authenticatable
  include Authorizable
  include RecordNotFoundRescue
  include RenderWithSerializer
  include RenderWithRoot

  skip_before_action :verify_authenticity_token
  before_action :authenticate

  def current_user
    @current_user ||= begin
      return if request.headers['Authorization'].blank?

      User.find_by(token: request.headers['Authorization'])
    end
  end
end
