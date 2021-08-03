module Statistics
  class CompanySerializer < Blueprinter::Base
    identifier :id, name: :company_id

    field :total_revenue do |company|
      company.flights.sum do |flight|
        flight.bookings.sum { |booking| booking.no_of_seats * booking.seat_price }
      end
    end

    field :total_no_of_booked_seats do |company|
      company.flights.sum do |flight|
        flight.bookings.sum(:no_of_seats)
      end
    end

    field :average_price_of_seats do |company|
      total_revenue = company.flights.sum do |flight|
        flight.bookings.sum { |booking| booking.no_of_seats * booking.seat_price }
      end

      total_no_of_booked_seats = company.flights.sum do |flight|
        flight.bookings.sum(:no_of_seats)
      end

      total_no_of_booked_seats != 0 ? total_revenue / total_no_of_booked_seats.to_f : 0
    end
  end
end
