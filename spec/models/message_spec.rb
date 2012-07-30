require 'spec_helper'

describe Message do
  before { FactoryGirl.create(:message) }

  it { should belong_to(:sender) }

  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:created_at) }
  it { should validate_presence_of(:twitter_id) }

  it { should validate_uniqueness_of(:twitter_id) }
end
