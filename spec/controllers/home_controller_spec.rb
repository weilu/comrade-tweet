require 'spec_helper'

describe HomeController do

  let(:current_user) { FactoryGirl.create(:user) }

  describe '#index' do
    let(:all_messages) {
      messages_filename = Rails.root.join('spec', 'fixtures', 'messages.json')
      File.open(messages_filename) { |f| JSON.load f }
    }
    let(:fake_client) { double(:twitter_client).as_null_object }

    before do
      fake_credentials = {'access_token' => 'fake_access_token',
                          'access_secret' => 'fake_access_secret'}
      controller.stub(:session).and_return fake_credentials
      controller.stub(:current_user).and_return current_user
      controller.stub_chain(:client).and_return(fake_client)
      fake_client.stub(:direct_messages).and_return(all_messages)

      get :index
    end

    it { should respond_with(:success) }

    it "queries twitter for direct messages that are newer than the user's newest dm in db" do
      Message.destroy_all
      FactoryGirl.create(:message, twitter_id: '1234567', user: current_user)
      FactoryGirl.create(:message, twitter_id: '2234569')
      fake_client.should_receive(:direct_messages).with(since_id: 1234567)

      get :index
    end

    it 'filters the direct messages with predefined regex' do
      direct_messages = assigns(:direct_messages)
      expect(direct_messages).to eq all_messages.select{ |m| m['text'].match(/^\{nc\}/) }
    end

    it 'stores filtered messages and senders in the database' do
      direct_messages = assigns(:direct_messages)
      direct_message_ids = direct_messages.map{ |m| m['id_str'] }
      new_messages = Message.limit(2).order('twitter_id desc')

      expect(new_messages.map(&:twitter_id)).to match_array(direct_message_ids)
      expect(new_messages.map(&:user).uniq).to eq [ current_user ]

      sender_ids = direct_messages.map{ |m| m['sender']['id_str'] }
      senders = new_messages.map(&:sender)
      expect(senders.map(&:persisted?).uniq).to eq [ true ]
      expect(senders.map(&:twitter_id)).to match_array(sender_ids)
    end

  end

  describe '#approve' do
    it 'sends a tweet to twitter'
    it 'marks the message as approved in db'
  end

end