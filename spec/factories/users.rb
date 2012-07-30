# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    provider "twitter"
    uid { Faker::Internet.user_name }
    name { Faker::Name.name }
  end
end
