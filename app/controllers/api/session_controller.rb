module Api
  class SessionController < ApplicationController
    skip_before_action :authenticate, only: [:create]

    def create
      user = User.find_by(email: params[:session][:email])
      if user.authenticate(params[:session][:password])
        response.headers['Authorization'] = user.token
        render json: { session: { token: user.token, user: user } }, status: :created
      else
        render json: { errors: { credentials: ['are invalid'] } }, status: :bad_request
      end
    end

    def delete
      User.find_by(token: request.headers['Authorization']).regenerate_token
      render json: { message: 'Logged out.' }, status: :no_content
    end
  end
end
