require 'spec_helper'

describe UsersController do

  let(:current_user) { FactoryGirl.create(:user, filter_regex: '^\{nc\}') }

  before { controller.stub(:current_user).and_return current_user }

  describe '#edit' do
    render_views

    it "displays current user's regex filter in a text field" do
      get :edit
      page = Capybara.string(response.body)
      expect(page.find_field('user_filter_regex').value).to eq current_user.filter_regex
    end

    it "displays current user's twitter username" do
      get :edit
      page = Capybara.string(response.body)
      expect(page).to have_content("@#{current_user.name}")
    end
  end

  describe '#update' do
    subject(:update_filter) { put :update, user: {filter_regex: 'nc'} }

    it "updates the user's regex filter" do
      update_filter
      expect(current_user.reload.filter_regex).to eq 'nc'
    end

    it "destroys user's stored messages" do
      FactoryGirl.create_list(:message, 2, user: current_user)
      expect{
        update_filter
      }.to change(Message, :count).by(-2)

      expect(current_user.messages.count).to  eq 0
    end
  end

end