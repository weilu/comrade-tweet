require 'spec_helper'

describe Sender do
  before { FactoryGirl.create(:sender) }

  it { should have_many(:messages) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:screen_name) }
  it { should validate_presence_of(:profile_image_url) }
  it { should validate_presence_of(:twitter_id) }

  it { should validate_uniqueness_of(:twitter_id) }
end
