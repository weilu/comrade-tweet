class Sender < ActiveRecord::Base
  attr_accessible :name, :screen_name, :profile_image_url
  has_many :messages

  validates_presence_of :name, :screen_name, :profile_image_url, :twitter_id
  validates_uniqueness_of :twitter_id

  def self.create_from_twitter_user sender
    find_or_initialize_by_twitter_id(sender[:id]).tap do |user|
      user.attributes = sender.slice(:screen_name, :name, :profile_image_url)
      user.save
    end
  end
end
