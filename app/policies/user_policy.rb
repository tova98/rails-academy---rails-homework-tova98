class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? || record == user
  end

  def update?
    user.admin? || record == user
  end

  def destroy?
    user.admin? || record == user
  end

  def permitted_attributes
    allowed_list = [:first_name, :last_name, :password, :email]
    user&.admin? ? allowed_list.push(:role) : allowed_list
  end
end
