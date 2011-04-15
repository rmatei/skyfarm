class CreateBillingPeriods < ActiveRecord::Migration
  def self.up
    create_table :billing_periods do |t|
      t.datetime :start_time
      t.datetime :end_time
      
      t.timestamps
    end
  end

  def self.down
    drop_table :billing_periods
  end
end
