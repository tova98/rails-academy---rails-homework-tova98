module Admin
  class UsersController < Admin::BaseController
    def index
      @q = User.all.page(params[:page]).per(10).ransack(params[:q])
      @users = @q.result
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        flash[:success] = 'User was successfully created.'
        redirect_to admin_users_path
      else
        flash[:danger] = 'User could not be created.'
        render :new
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])

      if @user.update(user_params)
        flash[:success] = 'User was successfully updated.'
        redirect_to admin_users_path
      else
        flash[:danger] = 'User could not be updated.'
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])

      @user.destroy

      flash[:success] = 'User was successfully deleted.'
      redirect_to admin_users_path
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :role)
    end
  end
end
