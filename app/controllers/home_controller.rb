class HomeController < ApplicationController
  def index
    if session['access_token'] && session['access_secret']
      @direct_messages = client.direct_messages
    end
  end
end