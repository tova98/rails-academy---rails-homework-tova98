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
  field :no_of_booked_seats do |flight|
    flight.bookings.sum(:no_of_seats)
  end

  field :company_name do |flight|
    flight.company.name
  end

  field :current_price

  association :company, blueprint: CompanySerializer
end
