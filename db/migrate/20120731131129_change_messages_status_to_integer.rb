class ChangeMessagesStatusToInteger < ActiveRecord::Migration
  def up
      remove_column :messages, :status
      add_column :messages, :status, :integer, limit: 1
    end

    def down
      remove_column :messages, :status
      add_column :messages, :status, :string
    end
end
