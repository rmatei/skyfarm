# random url for me to update who's paid
class HerestrauController < ApplicationController
  active_scaffold :payments do |config|
    # Limited column display for usability
    # config.columns = [:start_time, :end_time, :created_at]    

    # Latest first
    config.list.sorting = { :billing_period_id => :desc }

    config.actions = [:list, :show, :search, :update]
  end
end
