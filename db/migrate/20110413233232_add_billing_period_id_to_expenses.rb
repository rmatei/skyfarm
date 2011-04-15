class AddBillingPeriodIdToExpenses < ActiveRecord::Migration
  def self.up
    add_column :expenses, :billing_period_id, :integer
    add_column :tallied_consumptions, :billing_period_id, :integer
  end

  def self.down
    remove_column :expenses, :billing_period_id
    remove_column :tallied_consumptions, :billing_period_id
  end
end
