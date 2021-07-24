class FlightSerializer < Blueprinter::Base
  identifier :id

  fields :name,
         :no_of_seats,
         :base_price,
         :departs_at,
         :arrives_at,
         :company_id,
         :created_at,
         :updated_at

  association :company, blueprint: CompanySerializer
end
