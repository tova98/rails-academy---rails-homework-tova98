class BookingSerializer < Blueprinter::Base
  identifier :id

  fields :no_of_seats, :seat_price, :user_id, :flight_id, :created_at, :updated_at
  field :total_price do |booking|
    booking.no_of_seats * booking.seat_price
  end

  association :user, blueprint: UserSerializer
  association :flight, blueprint: FlightSerializer
end
