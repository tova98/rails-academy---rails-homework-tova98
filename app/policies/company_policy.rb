class CompanyPolicy < ApplicationPolicy
  def create?
    return if user.nil?

    user.role == 'admin'
  end

  def update?
    return if user.nil?

    user.role == 'admin'
  end

  def destroy?
    return if user.nil?

    user.role == 'admin'
  end
end
