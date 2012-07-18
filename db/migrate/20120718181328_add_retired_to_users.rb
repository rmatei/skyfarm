class AddRetiredToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :retired, :boolean, :default => false
  end

  def self.down
    remove_column :users, :retired
  end
end
