require 'spec_helper'

describe HomeController do

  describe '#index' do
    let(:all_messages) {
      messages_filename = Rails.root.join('spec', 'fixtures', 'messages.json')
      File.open(messages_filename) { |f| JSON.load f }
    }

    before do
      fake_credentials = {'access_token' => 'fake_access_token',
                          'access_secret' => 'fake_access_secret'}
      controller.stub(:session).and_return fake_credentials
      controller.stub_chain(:client, :direct_messages).and_return(all_messages)

      get :index
    end

    it { should respond_with(:success) }

    it 'filters the direct messages with predefined regex' do
      direct_messages = assigns(:direct_messages)
      expect(direct_messages).to eq all_messages.select{ |m| m['text'].match(/^\{nc\}/) }
    end
  end

  describe '#approve' do
    it 'sends a tweet to twitter'
    it 'marks the message as approved in db'
  end

end