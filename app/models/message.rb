class Message < ActiveRecord::Base
  belongs_to :sender
  belongs_to :user

  validates_presence_of :text, :created_at, :twitter_id
  validates_uniqueness_of :twitter_id
end
