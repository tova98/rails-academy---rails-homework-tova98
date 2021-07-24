# == Schema Information
#
# Table name: flights
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  no_of_seats :integer
#  base_price  :float            not null
#  departs_at  :datetime         not null
#  arrives_at  :datetime         not null
#  company_id  :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Flight < ApplicationRecord
  belongs_to :company

  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :company_id }
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }
  validates :departs_at, presence: true
  validates :arrives_at, presence: true
  validate :departs_before_arrives
  validates :base_price, presence: true, numericality: { greater_than: 0 }

  def departs_before_arrives
    return unless departs_at.present? && arrives_at.present?
    return if departs_at.before? arrives_at

    errors.add(:departs_at, 'must depart before it arrives')
  end
end
