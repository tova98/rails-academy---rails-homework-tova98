class CompanyPolicy < ApplicationPolicy
  def create?
    return if user.nil?

    user.admin?
  end

  def update?
    return if user.nil?

    user.admin?
  end

  def destroy?
    return if user.nil?

    user.admin?
  end
end
