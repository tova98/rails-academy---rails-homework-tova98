class BookingsQuery
  attr_reader :relation

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
