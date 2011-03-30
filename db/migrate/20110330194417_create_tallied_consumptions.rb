class CreateTalliedConsumptions < ActiveRecord::Migration
  def self.up
    create_table :tallied_consumptions do |t|
      t.integer :user_id
      t.integer :tallied_item_id
      t.integer :number

      t.timestamps
    end
  end

  def self.down
    drop_table :tallied_consumptions
  end
end
