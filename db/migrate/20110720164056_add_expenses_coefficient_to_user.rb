class AddExpensesCoefficientToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :expenses_coefficient, :float, :default => 1
    rename_column :users, :food_multiplier, :food_coefficient
    change_column_default :users, :food_coefficient, 1
  end

  def self.down
    remove_column :users, :expenses_coefficient
  end
end
