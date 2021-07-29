class Session
  include ActiveModel::Model
  attr_accessor :token, :user

  def initialize(user)
    @user = user
    @token = @user.token if @user.present?
  end

  def valid?(password)
    @user.authenticate(password) if @user.present?
  end
end
