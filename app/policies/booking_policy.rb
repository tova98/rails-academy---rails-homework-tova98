class BookingPolicy < ApplicationPolicy
  def show?
    user.admin? || record.user == user
  end

  def update?
    user.admin? || record.user == user
  end

  def destroy?
    user.admin? || record.user == user
  end

  def permitted_attributes
    if user.admin?
      [:no_of_seats, :user_id, :flight_id]
    else
      [:no_of_seats, :flight_id]
    end
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
