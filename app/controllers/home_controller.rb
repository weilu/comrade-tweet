class HomeController < ApplicationController
  MESSAGE_FILTER = Regexp.new /^\{nc\}/

  def index
    if session['access_token'] && session['access_secret']
      most_recent_message_id = current_user.messages.maximum(:twitter_id).to_i
      @direct_messages = client.direct_messages(since_id: most_recent_message_id).select{ |m| m['text'] =~ MESSAGE_FILTER }
      save_messages_and_senders
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

  private
  def save_messages_and_senders
    @direct_messages.each do |dm|
      message = Message.new
      message.twitter_id = dm['id_str']
      message.text = dm['text']
      message.created_at = dm['created_at']

      sender = dm['sender']
      options = { screen_name: sender['screen_name'],
                  name: sender['name'],
                  profile_image_url: sender['profile_image_url'] }
      message.sender = Sender.find_or_create_by_twitter_id(sender['id_str'], options)

      message.user = current_user
      message.save
    end
  end
end