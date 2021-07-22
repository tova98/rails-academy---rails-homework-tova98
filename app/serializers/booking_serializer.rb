class BookingSerializer < Blueprinter::Base
  identifier :id

  fields :no_of_seats, :seat_price, :created_at, :updated_at

  view :normal do
    fields :user_id, :flight_id
    association :user, blueprint: UserSerializer
    association :flight, blueprint: FlightSerializer
  end
end
