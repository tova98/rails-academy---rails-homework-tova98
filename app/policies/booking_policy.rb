class BookingPolicy < ApplicationPolicy
  def index?
    return if user.nil?

    user.role == 'admin'
  end

  def show?
    return if user.nil?

    user.role == 'admin'
  end

  def update?
    return if user.nil?

    return true if user.id == record.user_id

    user.role == 'admin'
  end

  def destroy?
    return if user.nil?

    return true if user.id == record.user_id

    user.role == 'admin'
  end
end
