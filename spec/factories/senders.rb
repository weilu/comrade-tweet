# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sender do
    twitter_id { Faker::Name.name.parameterize }
    name { Faker::Name.name }
    screen_name { Faker::Internet.user_name }
    profile_image_url { Faker::Internet.url }
  end
end
