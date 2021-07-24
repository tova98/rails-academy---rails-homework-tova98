FactoryBot.define do
  factory :booking do
    association :user
    association :flight

    no_of_seats { 2 }
    seat_price { 300 }
  end
end
