class BookingPolicy < ApplicationPolicy
  def index?
    return if user.nil?

    return true if record.find { |b| b.user_id == user.id }

    user.admin?
  end

  def show?
    return if user.nil?

    return true if user.id == record.user_id

    user.admin?
  end

  def create?
    return if user.nil?

    record.user_id = user.id if record.user_id.nil?

    return true if user.id == record.user_id

    user.admin?
  end

  def update?
    return if user.nil?

    return true if user.id == record.user_id

    user.admin?
  end

  def destroy?
    return if user.nil?

    return true if user.id == record.user_id

    user.admin?
  end

  def permitted_attributes
    if user.admin?
      [:seat_price, :no_of_seats, :user_id, :flight_id]
    else
      [:seat_price, :no_of_seats, :flight_id]
    end
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
