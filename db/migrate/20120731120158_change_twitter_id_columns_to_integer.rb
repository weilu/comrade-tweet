class ChangeTwitterIdColumnsToInteger < ActiveRecord::Migration
  def up
    remove_column :messages, :twitter_id
    add_column :messages, :twitter_id, :integer, limit: 8

    remove_column :senders, :twitter_id
    add_column :senders, :twitter_id, :integer, limit: 8
  end

  def down
    remove_column :messages, :twitter_id
    add_column :messages, :twitter_id, :string

    remove_column :senders, :twitter_id
    add_column :senders, :twitter_id, :string
  end
end
