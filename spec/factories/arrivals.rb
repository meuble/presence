FactoryBot.define do
  factory :arrival do
    user
    applies_on { Faker::Date.backward() }
    electricity_metric { Faker::Number.leading_zero_number(10) }
    water_metric { Faker::Number.leading_zero_number(10) }
  end
end
