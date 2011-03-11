class ExpensesController < ApplicationController
  
  active_scaffold :expense do |config|    
    # Limited column display for usability
    config.columns = [:user, :type, :amount, :note, :created_at]
    
    # If using full display, comment line above and uncomment lines below
    # config.columns << :type_id
    # config.columns << :venmo_transaction_id
    # config.columns[:venmo_transaction_id].label = 'Venmo transaction ID'
    
    # Latest first
    config.list.sorting = { :created_at => :desc }
    
    # Don't allow any changes to DB, just reading
    config.actions = [:list, :show, :search]
  end
  
end
