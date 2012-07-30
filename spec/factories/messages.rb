# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    twitter_id { Faker::Name.name.parameterize }
    text { Faker::Lorem.sentence }
    created_at { Time.now }
  end
end
