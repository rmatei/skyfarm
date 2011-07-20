class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :venmo_id, :null => false
      t.string :venmo_username
      t.integer :facebook_id, :limit => 8
      t.string :first_name
      t.string :last_name
      t.string :profile_picture
      t.string :email
      t.float :monthly_rent
      t.float :food_coefficient

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
