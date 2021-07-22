class FlightSerializer < Blueprinter::Base
  identifier :id

  fields :name,
         :no_of_seats,
         :base_price,
         :departs_at,
         :arrives_at,
         :company_id
end
