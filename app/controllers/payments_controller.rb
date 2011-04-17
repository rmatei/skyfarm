class PaymentsController < ApplicationController
  active_scaffold :payments do |config|
    # Limited column display for usability
    # config.columns = [:start_time, :end_time, :created_at]    

    # Latest first
    config.list.sorting = { :billing_period_id => :desc }

    # Don't allow any changes to DB, just reading
    config.actions = [:list, :show, :search, :update]
  end
  
  # shows sample bill email from a payment
  def email
    @payment = Payment.find(params[:id])
    @user = @payment.user
    @billing_period = @payment.billing_period
    render :template => 'notifier/bill'
  end
end
