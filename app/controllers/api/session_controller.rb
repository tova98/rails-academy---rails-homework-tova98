module Api
  class SessionController < ApplicationController
    skip_before_action :authenticate, only: [:create]

    def create
      @session = Session.new(User.find_by(email: params[:session][:email]))

      if @session.valid?(params[:session][:password])
        render json: SessionSerializer.render(@session, root: :session), status: :created
      else
        render json: { errors: { credentials: ['are invalid'] } }, status: :bad_request
      end
    end

    def destroy
      current_user.regenerate_token
      render json: { message: 'Logged out.' }, status: :no_content
    end
  end

  class Session
    include ActiveModel::Model
    attr_accessor :token, :user

    def initialize(new_user)
      @user = new_user
      @token = @user.token if @user.present?
    end

    def valid?(password)
      @user.authenticate(password) if @user.present?
    end
  end

  class SessionSerializer < Blueprinter::Base
    field :token

    association :user, blueprint: UserSerializer
  end
end
