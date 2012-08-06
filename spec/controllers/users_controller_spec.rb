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
    it "updates the user's regex filter" do
      put :update, user: { filter_regex: 'nc' }
      expect(current_user.reload.filter_regex).to eq 'nc'
    end
  end

end