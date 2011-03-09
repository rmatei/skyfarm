class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.integer :from_user_id, :null => false
      t.integer :to_user_id, :null => false
      t.float :amount, :null => false
      t.string :note
      t.integer :type_id, :null => false
      t.integer :venmo_transaction_id
      t.string :pay_or_charge

      t.timestamps
    end
  end

  def self.down
    drop_table :expenses
  end
end
