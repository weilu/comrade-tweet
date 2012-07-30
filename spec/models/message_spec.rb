require 'spec_helper'

describe Message do
  it { should belong_to(:sender) }

  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:created_at) }
  it { should validate_presence_of(:twitter_id) }
end
