# == Schema Information
#
# Table name: bookings
#
#  id          :bigint           not null, primary key
#  no_of_seats :integer          not null
#  seat_price  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  flight_id   :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_bookings_on_flight_id  (flight_id)
#  index_bookings_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (flight_id => flights.id)
#  fk_rails_...  (user_id => users.id)
#
class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :flight

  before_validation :update_seat_price, on: :create

  validates :seat_price, presence: true, numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }
  validates_associated :flight
  validate :flight_in_past

  validate :total_booked_seats

  def update_seat_price
    return if flight.blank?

    self.seat_price = flight.current_price
  end

  def flight_in_past
    return unless flight.present? && flight.departs_at.present? &&
                  flight.departs_at.before?(DateTime.current)

    errors.add(:flight, 'must not be in past')
  end

  def total_booked_seats
    return if flight.blank? || no_of_seats.blank?
    return unless Booking.where('flight_id = ? AND id != COALESCE(?, -1)', flight.id, id)
                         .sum(:no_of_seats) + no_of_seats > flight.no_of_seats

    errors.add(:flight, "can't be overbooked")
  end
end
