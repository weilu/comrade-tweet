class AddFilterRegexToUsers < ActiveRecord::Migration
  def change
    add_column :users, :filter_regex, :string
  end
end
