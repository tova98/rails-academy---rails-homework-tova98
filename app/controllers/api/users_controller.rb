module Api
  class UsersController < ApplicationController
    skip_before_action :authenticate, only: [:create]

    def index
      @users = User.all
      authorize @users

      render_with_root(request.headers['X_API_SERIALIZER_ROOT'])
    end

    def show
      @user = User.find(params[:id])
      authorize @user

      render_with_serializer(request.headers['X_API_SERIALIZER'])
    end

    def create
      @user = User.new(permitted_attributes(@user))

      if @user.save
        render json: UserSerializer.render(@user, root: :user), status: :created
      else
        render json: { errors: @user.errors.as_json }, status: :bad_request
      end
    end

    def update
      @user = User.find(params[:id])
      authorize @user

      if @user.update(permitted_attributes(@user))
        render json: UserSerializer.render(@user, root: :user)
      else
        render json: { errors: @user.errors.as_json }, status: :bad_request
      end
    end

    def destroy
      @user = User.find(params[:id])
      authorize @user

      if @user.destroy
        render json: { messages: ['User has been deleted.'] }, status: :no_content
      else
        render json: { errors: @user.errors.as_json }, status: :bad_request
      end
    end
  end
end
