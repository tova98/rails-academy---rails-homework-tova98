class FlightsQuery
  attr_reader :relation

  def self.filtered(records, name_filter, departs_at_filter, seats_filter)
    records = new(records).with_name_contains(name_filter) if name_filter.present?
    records = new(records).with_departs_at_eq(departs_at_filter) if departs_at_filter.present?
    records = new(records).with_no_of_available_seats_gteq(seats_filter) if seats_filter.present?
    records
  end

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
    relation.where("DATE_TRUNC('minute', departs_at) = DATE_TRUNC('minute', timestamp ?)", datetime)
  end

  def with_no_of_available_seats_gteq(seats)
    relation.select('flights.*')
            .left_outer_joins(:bookings)
            .group(:id)
            .having('flights.no_of_seats - COALESCE(SUM(bookings.no_of_seats), 0) >= ?', seats)
  end
end
