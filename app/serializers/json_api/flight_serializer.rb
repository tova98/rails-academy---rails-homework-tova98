module JsonApi
  class FlightSerializer
    include JSONAPI::Serializer
    attributes :id,
               :name,
               :no_of_seats,
               :base_price,
               :departs_at,
               :arrives_at,
               :created_at,
               :updated_at,
               :company,
               :company_id
  end
end
