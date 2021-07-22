# == Schema Information
#
# Table name: bookings
#
#  id          :bigint           not null, primary key
#  no_of_seats :integer          not null
#  seat_price  :float            not null
#  user_id     :bigint
#  flight_id   :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :flight

  validates :seat_price, presence: true, numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }
  validates_associated :flight
  validate :departs_in_past

  def departs_in_past
    return unless flight.present? && flight.departs_at.present? &&
                  flight.departs_at.before?(DateTime.current)

    errors.add(:departs_at, 'must not be in past')
  end
end
