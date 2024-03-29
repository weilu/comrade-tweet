require 'spec_helper'

describe HomeController do

  let(:current_user) { FactoryGirl.create(:user, filter_regex: '^\{nc\}') }
  let(:fake_client) { double(:twitter_client).as_null_object }

  before do
    fake_credentials = {'access_token' => 'fake_access_token',
                        'access_secret' => 'fake_access_secret'}
    controller.stub(:session).and_return fake_credentials
    controller.stub(:current_user).and_return current_user
    controller.stub_chain(:client).and_return(fake_client)
  end

  def parse_fixtures file_name
    File.open(Rails.root.join('spec', 'fixtures', file_name)) { |f| JSON.load f }
  end

  describe '#index' do
    let(:all_messages) { parse_fixtures 'messages.json' }
    let(:all_mentions) { parse_fixtures 'mentions.json' }
    let(:filtered_messages) { all_mentions + all_messages.select { |m| m['text'].match(/#{current_user.filter_regex}/) } }

    before do
      fake_client.stub(:direct_messages).and_return(all_messages)
      fake_client.stub(:mentions_timeline).and_return(all_mentions)
      Message.stub(:create_from_tweet_for_user)
    end

    subject(:do_request) { get :index }

    it { should be_success }

    describe 'queries twitter for DM and mentions' do
      it "queries twitter for direct messages that are newer than the user's newest dm in db" do
          Message.destroy_all
          FactoryGirl.create(:message, twitter_id: 1234567, user: current_user)
          FactoryGirl.create(:message, twitter_id: 2234569)
          fake_client.should_receive(:direct_messages).with(since_id: 1234567, count: 200)
          fake_client.should_receive(:mentions_timeline).with(since_id: 1234567, count: 200)

          do_request
      end

      context 'when user has no stored message' do
        it 'does not query with since_id' do
          Message.destroy_all
          fake_client.should_receive(:direct_messages).with(count: 200)
          fake_client.should_receive(:mentions_timeline).with(count: 200)

          do_request
        end
      end
    end

    it 'stores filtered messages and senders in the database' do
      filtered_messages.each do |m|
        Message.should_receive(:create_from_tweet_for_user).with(m, current_user)
      end

      do_request
    end

    it "assigns direct_messages with current user's sorted pending messages" do
      Message.destroy_all
      early_pending_message = FactoryGirl.create(:message, :pending, created_at: 2.days.ago, user: current_user)
      pending_message = FactoryGirl.create(:message, :pending, user: current_user)
      other_message = FactoryGirl.create(:message, :pending)

      do_request
      direct_messages = assigns(:direct_messages).to_a

      expect(direct_messages).to eq([pending_message, early_pending_message])
    end
  end

  describe '#approve' do
    let(:message) { FactoryGirl.create(:message, status: MessageStatus::PENDING) }
    let(:tweet_text) { "#{message.text} via boo" }

    it 'sends a tweet to twitter' do
      fake_client.should_receive(:update).with tweet_text
      post :approve, id: message.id, text: tweet_text
    end

    it 'marks the message as approved in db' do
      post :approve, id: message.id, text: tweet_text
      expect(Message.find(message.id).status).to eq MessageStatus::APPROVED
    end
  end

  describe '#reject' do
    let(:message) { FactoryGirl.create(:message, status: MessageStatus::PENDING) }

    it 'does not send a tweet to twitter' do
      fake_client.should_not_receive(:update)
      post :reject, id: message.id
    end

    it 'marks the message as rejected in db' do
      post :reject, id: message.id
      expect(Message.find(message.id).status).to eq MessageStatus::REJECTED
    end
  end
end