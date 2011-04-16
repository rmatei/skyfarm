class BillingPeriodsController < ApplicationController
  active_scaffold :billing_periods do |config|
    # Limited column display for usability
    # config.columns = [:start_time, :end_time, :created_at]    

    # Latest first
    config.list.sorting = { :start_time => :desc }

    # Don't allow any changes to DB, just reading
    config.actions = [:list, :show, :search]
  end
end
