class UsersController < ApplicationController
  
  active_scaffold :user do |config|
    config.columns << :venmo_id
    config.columns[:venmo_id].label = 'Venmo ID'
    config.create.columns.remove :expenses
    
    config.actions = [:list, :show]
  end
  
end
