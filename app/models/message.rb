class Message < ActiveRecord::Base
  belongs_to :sender
  belongs_to :user

  validates_presence_of :text, :created_at, :twitter_id
  validates_uniqueness_of :twitter_id

  scope :pending, where(status: MessageStatus::PENDING)

  def self.create_from_tweet_for_user tweet, user
    message = Message.new
    message.twitter_id = tweet['id']
    message.text = tweet['text']
    message.created_at = tweet['created_at']
    message.status = MessageStatus::PENDING

    sender = (tweet['sender'] || tweet['user']).to_hash
    message.sender = Sender.create_from_twitter_user sender

    message.user = user
    message.save
    message
  end
end
