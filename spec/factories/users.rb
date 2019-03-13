FactoryBot.define do
  factory :user do
    name { Faker.name }
    email { Faker::Internet.email }
  end
end
