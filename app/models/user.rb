class User < ActiveRecord::Base
  has_many :messages

  def self.from_omniauth auth
    where(auth.slice('provider', 'uid')).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth auth
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['info']['nickname']
    end
  end

  def last_stored_message_id
    messages.maximum(:twitter_id)
  end

  def pending_messages
    messages.where(status: MessageStatus::PENDING)
  end
end
