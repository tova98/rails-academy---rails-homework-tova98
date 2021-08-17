class BookingsQuery
  attr_reader :relation

  def self.all(scope, params)
    sorted_records = new(scope).sorted

    return sorted_records unless params['filter'].present? && params['filter'] == 'active'

    new(sorted_records).with_active_flights
  end

  def initialize(relation = Booking.all)
    @relation = relation
  end

  def sorted
    relation.select('bookings.*')
            .joins(:flight)
            .order(:departs_at, :name, :created_at)
  end

  def with_active_flights
    relation.select('bookings.*')
            .joins(:flight)
            .where('departs_at > ?', DateTime.current)
  end
end
