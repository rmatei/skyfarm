class ExpensesController < ApplicationController
  
  active_scaffold :expense do |config|
    config.columns << :venmo_transaction_id
    config.columns[:venmo_transaction_id].label = 'Venmo transaction ID'
    
    config.actions.exclude [:create, :update, :delete]
  end
  
end
