class Sender < ActiveRecord::Base
  attr_accessible :name, :screen_name, :profile_image_url
  has_many :messages

  validates_presence_of :name, :screen_name, :profile_image_url, :twitter_id
  validates_uniqueness_of :twitter_id
end
