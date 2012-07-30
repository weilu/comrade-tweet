class CreateSenders < ActiveRecord::Migration
  def change
    create_table :senders do |t|
      t.string :screen_name
      t.text :profile_image_url
      t.string :name
      t.string :twitter_id
    end
  end
end
