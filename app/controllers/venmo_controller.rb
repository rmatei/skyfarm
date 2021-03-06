require 'base64'

class VenmoController < ApplicationController

  # takes Venmo API call, creates new expense
  def track_receipt_v2
    data = parse_params(params)
    payments = get_payments(data)
    
    payments.each do |payment|
      # only save Skyfarm-related expenses
      if(payment["from_user"]["full_name"].downcase.include?("skyfarm") and payment["amount"].to_f > 0)
        save_expense(payment)
      else
        Rails.logger.info "Not tracking transaction from #{payment["from_user"]["full_name"]} to #{payment["to_user"]["full_name"]}."
      end
    end
    
    render :text => "ok"
  end

  def track_receipt
    Rails.logger.info "Call to deprecated API endpoint."
    render :text => "deprecated"
  end
  

private
  
  # deserializes data we got from Venmo
  def parse_params(params)
    data = params.select {|k,v| k.to_s.include? "payment"}
    data = data[0][0]
    data = JSON.parse data
    Rails.logger.info "Parsed hash from API: #{data.inspect}"
    
    return data
  end

  def get_payments(params)
    Rails.logger.info "Got params: #{params.inspect}"
    payments = params['payments'].split('.')[1]
    payments = Base64.decode64(payments)
    payments += ']' if payments[-1,1] == '}'
    payments += '}]' unless payments[-2,2] == '}]'
    payments = JSON.parse(payments)
    Rails.logger.info "Got payments from API: #{payments.inspect}"
    return payments
  end

  # takes parsed data from venmo api and saves it to the database
  def save_expense(data)
    payer = save_user(data["to_user"])
    expense = Expense.new(:user => payer,
                          :amount => data["amount"].to_f,
                          :note => data["note"],
                          :venmo_transaction_id => data["transaction_id"],
                          :pay_or_charge => data["pay_or_charge"])
    expense.set_type_from_venmo_transaction(data["from_user"]["full_name"])
    expense.save!
    Rails.logger.info "Saved expense #{expense.note}."
  end

  def save_user(user_data)
    venmo_id = user_data["user_id"].to_i
    user = User.find_by_venmo_id(venmo_id) || User.new(:venmo_id => venmo_id)
    user.venmo_username = user_data["username"]
    user.facebook_id = user_data["facebook_id"].to_i
    user.first_name = user_data["first_name"]
    user.last_name = user_data["last_name"]
    user.profile_picture = user_data["profile_picture"]
    user.email = user_data["email"]
    user.save
    return user
  end

end
