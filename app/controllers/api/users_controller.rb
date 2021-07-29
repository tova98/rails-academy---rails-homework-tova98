module Api
  class UsersController < ApplicationController
    skip_before_action :authenticate, only: [:create]

    def index
      @users = authorize User.all

      render_with_root(request.headers['X_API_SERIALIZER_ROOT'])
    end

    def show
      @user = authorize User.find(params[:id])

      render_with_serializer(request.headers['X_API_SERIALIZER'])
    end

    def create
      @user = User.new(permitted_attributes(User))

      if @user.save
        render json: UserSerializer.render(@user, root: :user), status: :created
      else
        render json: { errors: @user.errors.as_json }, status: :bad_request
      end
    end

    def update
      @user = authorize User.find(params[:id])

      if @user.update(permitted_attributes(@user))
        render json: UserSerializer.render(@user, root: :user)
      else
        render json: { errors: @user.errors.as_json }, status: :bad_request
      end
    end

    def destroy
      @user = authorize User.find(params[:id])

      if @user.destroy
        render json: { messages: ['User has been deleted.'] }, status: :no_content
      else
        render json: { errors: @user.errors.as_json }, status: :bad_request
      end
    end
  end
end
