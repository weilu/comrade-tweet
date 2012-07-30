class Message < ActiveRecord::Base
  belongs_to :sender

  validates_presence_of :text, :created_at, :twitter_id
end
