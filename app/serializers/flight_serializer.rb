class FlightSerializer < Blueprinter::Base
  identifier :id

  fields :name,
         :no_of_seats,
         :base_price,
         :departs_at,
         :arrives_at,
         :created_at,
         :updated_at

  view :normal do
    fields :company_id
    association :company, blueprint: CompanySerializer
  end
end
