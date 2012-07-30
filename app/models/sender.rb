class Sender < ActiveRecord::Base
  has_many :messages

  validates_presence_of :name, :screen_name, :profile_image_url, :twitter_id
end
