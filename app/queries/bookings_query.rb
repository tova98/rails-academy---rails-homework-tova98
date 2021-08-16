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

  def self.all(scope, params)
    @bookings = BookingsQuery.new(scope).sorted

    return @bookings unless params['filter'].present? && params['filter'] == 'active'

    @bookings = BookingsQuery.new(@bookings).with_active_flights
  end
end
