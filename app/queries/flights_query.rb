class FlightsQuery
  attr_reader :relation

  def initialize(relation = Flight.all)
    @relation = relation
  end

  def sorted
    relation.order(:departs_at, :name, :created_at)
  end

  def with_active_flights
    relation.where('departs_at > ?', DateTime.current)
  end

  def with_name_contains(name)
    relation.where('name LIKE ?', "%#{name}%")
  end

  def with_departs_at_eq(datetime)
    relation.where('departs_at = ?', datetime)
  end

  def with_no_of_available_seats_gteq(seats)
    relation.select('flights.*')
            .left_outer_joins(:bookings)
            .group(:id)
            .having('flights.no_of_seats - COALESCE(SUM(bookings.no_of_seats), 0) >= ?', seats)
  end
end
