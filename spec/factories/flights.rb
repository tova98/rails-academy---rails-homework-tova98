FactoryBot.define do
  factory :flight do
    association :company

    sequence(:name) { |n| "Flight-#{n}" }
    no_of_seats { 50 }
    base_price { 2000 }
    departs_at { DateTime.current + 1 }
    arrives_at { DateTime.current + 2 }
  end
end
