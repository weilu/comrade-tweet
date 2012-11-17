class HomeController < ApplicationController

  def index
    if session['access_token'] && session['access_secret']
      save_messages_and_senders filtered_messages
      @direct_messages = current_user.pending_messages
    end
  end

  def approve
    message = Message.find params[:id]
    tweet_text = params[:text]
    client.update(tweet_text)
    message.update_attribute(:status, MessageStatus::APPROVED)

    render text: 'Mission accomplished!', status: 201
  end

  def reject
    message = Message.find params[:id]
    message.update_attribute(:status, MessageStatus::REJECTED)

    render text: 'Rejected!', status: 200
  end

  private
  def filtered_messages
    (new_messages + new_mentions).select{ |m| m['text'] =~ /#{current_user.filter_regex}/ }
  end

  def new_messages
    client.direct_messages(since_id: current_user.last_stored_message_id)
  end

  def new_mentions
    client.mentions_timeline(since_id: current_user.last_stored_message_id)
  end

  def save_messages_and_senders twitter_messages
    twitter_messages.each do |dm|
      message = Message.new
      message.twitter_id = dm['id']
      message.text = dm['text']
      message.created_at = dm['created_at']
      message.status = MessageStatus::PENDING

      sender = dm['sender'] || dm['user']
      options = { screen_name: sender['screen_name'],
                  name: sender['name'],
                  profile_image_url: sender['profile_image_url'] }
      message.sender = Sender.find_or_create_by_twitter_id(sender['id'], options)

      message.user = current_user
      message.save
    end
  end
end