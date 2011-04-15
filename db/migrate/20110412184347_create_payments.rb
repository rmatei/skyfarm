class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :user_id
      t.float :amount
      t.integer :billing_period_id
      t.boolean :paid, :default => false
      t.text :details

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
