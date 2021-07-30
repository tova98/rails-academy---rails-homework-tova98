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

  field :current_price do |flight|
    days_before = (flight.departs_at.to_date - DateTime.current.to_date).round
    if days_before >= 15
      flight.base_price
    else
      ((days_before / 15.0) * flight.base_price + flight.base_price).round
    end
  end

  association :company, blueprint: CompanySerializer
end
