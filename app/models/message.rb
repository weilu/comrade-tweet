class Message < ActiveRecord::Base
  belongs_to :sender
  belongs_to :user

  validates_presence_of :text, :created_at, :twitter_id
  validates_uniqueness_of :twitter_id

  def self.create_from_tweet_for_user tweet, user
    message = Message.new
    message.twitter_id = tweet['id']
    message.text = tweet['text']
    message.created_at = tweet['created_at']
    message.status = MessageStatus::PENDING

    sender = tweet['sender'] || tweet['user']
    options = sender.slice('screen_name', 'name', 'profile_image_url')
    message.sender = Sender.find_or_create_by_twitter_id(sender['id'], options)

    message.user = user
    message.save
    message
  end
end
