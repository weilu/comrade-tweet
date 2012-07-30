class HomeController < ApplicationController
  MESSAGE_FILTER = Regexp.new /^\{nc\}/

  def index
    if session['access_token'] && session['access_secret']
      @direct_messages = client.direct_messages.select{ |m| m['text'] =~ MESSAGE_FILTER }
    end
  end

  def approve
    message = params[:message]
    #new_tweet = client.update(message)

    original_message_id = params[:id]
    #mark as approved in db

    render text: 'Mission accomplished!', status: 201
  end

  def reject
    original_message_id = params[:id]
    #mark as rejected in db

    render text: 'Rejected!', status: 200
  end
end