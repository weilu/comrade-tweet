require 'spec_helper'

describe Message do
  before { FactoryGirl.create(:message) }

  it { should belong_to(:sender) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:created_at) }
  it { should validate_presence_of(:twitter_id) }

  it { should validate_uniqueness_of(:twitter_id) }

  describe ".create_from_tweet_for_user" do
    let(:tweet) do
      {
        "id" => 227428103931179009,
        "created_at" => "Mon Jul 23 15:41:00 +0000 2012",
        "text" => "The quick brown fox jumps over the lazy dog",
        sender_key => Twitter::User.new(sender_hash.symbolize_keys)
      }
    end
    let(:sender_key) { "sender" }
    let(:sender_hash) do
      {
        "id" => 12388,
        "screen_name" => "kenny",
        "name" => "Kenny",
        "profile_image_url" => "http://example.com/logo.png"
      }
    end
    let(:user) { mock_model("User") }

    it "sets a bunch of attributes based on the original tweet" do
      described_class.create_from_tweet_for_user(tweet, user)
      message = Message.last
      message.twitter_id.should == tweet['id']
      message.text.should == tweet['text']
      message.created_at.should == Time.parse(tweet['created_at'])
    end

    it "sets the status to pending" do
      described_class.create_from_tweet_for_user(tweet, user)
      Message.last.status.should == MessageStatus::PENDING
    end

    it "sets the user to the user passed in" do
      message = described_class.create_from_tweet_for_user(tweet, user)
      message.user.should == user
    end

    shared_examples_for "find or create sender" do
      it "sets the sender to the tweet sender" do
        described_class.create_from_tweet_for_user(tweet, user)

        sender = Message.last.sender
        sender.twitter_id.should == sender_hash['id']
        sender.screen_name.should == sender_hash['screen_name']
        sender.name.should == sender_hash['name']
        sender.profile_image_url.should == sender_hash['profile_image_url']
      end
    end

    context "when the tweet is a DM" do
      it_behaves_like "find or create sender"
    end

    context "when the tweet is a tweet" do
      let(:sender) { "user" }
      it_behaves_like "find or create sender"
    end
  end
end
