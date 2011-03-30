class CreateTalliedItems < ActiveRecord::Migration
  def self.up
    create_table :tallied_items do |t|
      t.string :name
      t.float :price

      t.timestamps
    end
  end

  def self.down
    drop_table :tallied_items
  end
end
