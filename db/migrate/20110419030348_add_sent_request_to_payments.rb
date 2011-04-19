class AddSentRequestToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :sent_request, :boolean, :default => false
  end

  def self.down
    remove_column :payments, :sent_request
  end
end
