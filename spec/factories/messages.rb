# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    sequence(:twitter_id)
    text { Faker::Lorem.sentence }
    created_at { Time.now }

    trait :pending do |message|
      message.status MessageStatus::PENDING
    end
  end
end
