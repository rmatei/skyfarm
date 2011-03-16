class UsersController < ApplicationController
  
  active_scaffold :user do |config|
    # Limited column display for usability
    config.list.columns = [:profile_picture, :full_name, :venmo_username, :total_spent, :expenses, :monthly_rent, :food_multiplier]
    
    # If using full display, comment line above and uncomment lines below
    # config.columns << :venmo_id
    # config.columns[:venmo_id].label = 'Venmo ID'
    
    # Fix for crash
    config.create.columns.remove :expenses
    
    # Don't allow any changes to DB, just reading
    config.actions = [:list, :show, :search]
  end
  
end
