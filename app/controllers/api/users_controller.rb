module Api
  class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_from_not_found

    def index
      @users = User.all

      render_with_root(request.headers['X_API_SERIALIZER_ROOT'])
    end

    def show
      @user = User.find(params[:id])
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

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        render json: UserSerializer.render(@user, root: :user)
      else
        render json: { errors: @user.errors.as_json }, status: :bad_request
      end
    end

    def destroy
      @user = User.find(params[:id])

      if @user.destroy
        render json: { messages: ['User has been deleted.'] }, status: :no_content
      else
        render json: { errors: @user.errors.as_json }, status: :bad_request
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end

    def rescue_from_not_found
      render json: { errors: ['User not found.'] }
    end

    def render_with_serializer(serializer)
      if serializer.blank? || serializer == 'blueprinter'
        render json: UserSerializer.render(@user, root: :user)
      elsif serializer == 'JSON:API'
        render json: { user: JsonApi::UserSerializer.new(@user)
                                                    .serializable_hash[:data][:attributes] }
      end
    end

    def render_with_root(root)
      if root.blank? || root == '1'
        render json: UserSerializer.render(@users, root: :users)
      elsif root == '0'
        render json: UserSerializer.render(@users)
      end
    end
  end
end
