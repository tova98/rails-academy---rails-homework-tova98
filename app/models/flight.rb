# == Schema Information
#
# Table name: flights
#
#  id          :bigint           not null, primary key
#  arrives_at  :datetime         not null
#  base_price  :integer          not null
#  departs_at  :datetime         not null
#  name        :string           not null
#  no_of_seats :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint
#
# Indexes
#
#  index_flights_on_company_id           (company_id)
#  index_flights_on_name_and_company_id  (name,company_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Flight < ApplicationRecord
  belongs_to :company

  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings

  scope :active, -> { where('departs_at > ?', DateTime.current) }

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :company_id }
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }
  validates :departs_at, presence: true
  validates :arrives_at, presence: true
  validate :departs_before_arrives
  validates :base_price, presence: true, numericality: { greater_than: 0 }
  validate :overlap

  def departs_before_arrives
    return unless departs_at.present? && arrives_at.present?
    return if departs_at.before? arrives_at

    errors.add(:departs_at, 'must depart before it arrives')
  end

  def overlap
    return if departs_at.blank? || arrives_at.blank?

    return if overlapping_flights.blank?

    errors.add(:departs_at, "can't overlap")
    errors.add(:arrives_at, "can't overlap")
  end

  def overlapping_flights
    Flight.where(company_id: company_id)
          .where.not(id: id)
          .where.not('departs_at >= timestamp ? OR arrives_at <= timestamp ?',
                     arrives_at, departs_at)
          .all
  end

  def current_price
    days_before = (departs_at.to_date - DateTime.current.to_date).round
    if days_before >= 15
      base_price
    elsif days_before <= 0
      base_price * 2
    else
      (((15 - days_before) / 15.0) * base_price + base_price).round
    end
  end
end
