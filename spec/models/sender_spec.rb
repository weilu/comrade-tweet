require 'spec_helper'

describe Sender do
  it { should have_many(:messages) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:screen_name) }
  it { should validate_presence_of(:profile_image_url) }
  it { should validate_presence_of(:twitter_id) }
end
