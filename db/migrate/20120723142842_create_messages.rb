class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :twitter_id
      t.string :text
      t.timestamp :created_at
      t.integer :sender_id
      t.string :status
    end
  end
end
