module Statistics
  class CompanySerializer < Blueprinter::Base
    identifier :id, name: :company_id

    field :total_revenue do |company|
      total_revenue(company)
    end

    field :total_no_of_booked_seats do |company|
      total_no_of_booked_seats(company)
    end

    field :average_price_of_seats do |company|
      total_booked_seats = total_no_of_booked_seats(company)
      total_booked_seats != 0 ? total_revenue(company) / total_booked_seats.to_f : 0
    end

    def self.total_revenue(company)
      company.flights.includes(:bookings).sum do |flight|
        flight.bookings.sum { |booking| booking.no_of_seats * booking.seat_price }
      end
    end

    def self.total_no_of_booked_seats(company)
      company.flights.sum do |flight|
        flight.bookings.sum(:no_of_seats)
      end
    end
  end
end
