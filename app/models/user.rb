# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string
#  password_digest :string           not null
#  role            :string
#  token           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_token  (token) UNIQUE
#
class User < ApplicationRecord
  has_secure_password
  has_secure_token

  nilify_blanks only: :password

  has_many :bookings, dependent: :destroy
  has_many :flights, through: :bookings

  enum role: { admin: 'admin' }

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :token, uniqueness: { index: true }
end
