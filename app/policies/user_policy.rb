class UserPolicy < ApplicationPolicy
  def index?
    return if user.nil?

    user.admin?
  end

  def show?
    return if user.nil?

    return true if user.id == record.id

    user.admin?
  end

  def update?
    return if user.nil?

    return true if user.id == record.id

    user.admin?
  end

  def destroy?
    return if user.nil?

    return true if user.id == record.id

    user.admin?
  end

  def permitted_attributes
    return [:first_name, :last_name, :password, :email] if user.nil?

    if user.admin?
      [:first_name, :last_name, :role, :password, :email]
    else
      [:first_name, :last_name, :password, :email]
    end
  end
end
