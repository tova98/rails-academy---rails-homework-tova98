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
  validates :departs_at, presence: true
  validates :arrives_at, presence: true
  validate :departs_before_arrives
  validate :departs_in_past
  validates :base_price, presence: true, numericality: { greater_than: 0 }

  def departs_before_arrives
    return unless departs_at.present? && arrives_at.present? && departs_at >= arrives_at

    errors.add(:departs_at, 'must depart before it arrives')
  end

  def departs_in_past
    return unless departs_at.present? && departs_at < DateTime.current

    errors.add(:departs_at, 'must not be in past')
  end
end
