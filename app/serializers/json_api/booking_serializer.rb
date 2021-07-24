module JsonApi
  class BookingSerializer
    include JSONAPI::Serializer
    attributes :id, :no_of_seats, :seat_price, :created_at, :updated_at,
               :user, :user_id, :flight, :flight_id
  end
end
