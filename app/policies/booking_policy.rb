class BookingPolicy < ApplicationPolicy
  def index?
    return if user.nil?

    return true if record.find { |b| b.user_id == user.id }

    user.role == 'admin'
  end

  def show?
    return if user.nil?

    return true if user.id == record.user_id

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

  def permitted_attributes
    if user.role == 'admin'
      [:seat_price, :no_of_seats, :user_id, :flight_id]
    else
      [:seat_price, :no_of_seats, :flight_id]
    end
  end
end
