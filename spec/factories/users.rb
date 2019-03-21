FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password_digest { Faker::Alphanumeric.alphanumeric(10) }
  end
end
