FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@email.com" }
    first_name { 'User' }
    last_name { 'User last' }
    password { 'password' }
    role { 'admin' }
  end
end
