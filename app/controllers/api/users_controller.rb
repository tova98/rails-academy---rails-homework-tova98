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
      @user = User.new(user_params)

      if @user.save
        render json: UserSerializer.render(@user, root: :user), status: :created
      else
        render json: { errors: @user.errors.as_json }, status: :bad_request
      end
    end

    def update # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      if (params[:id].to_i != current_user.id || params[:user][:role].present?) &&
         current_user.role != 'admin'
        render json: { error: 'Authorization denied' }, status: :forbidden
      else
        @user = User.find(params[:id])
        authorize @user

        if @user.update(user_params)
          render json: UserSerializer.render(@user, root: :user)
        else
          render json: { errors: @user.errors.as_json }, status: :bad_request
        end
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

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :role)
    end
  end
end
