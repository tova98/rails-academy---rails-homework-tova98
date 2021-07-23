class BookingSerializer < Blueprinter::Base
  identifier :id

  fields :no_of_seats, :seat_price, :user_id, :flight_id, :created_at, :updated_at

  association :user, blueprint: UserSerializer
  association :flight, blueprint: FlightSerializer
end
