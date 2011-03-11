class VenmoController < ApplicationController

  # takes Venmo API call, creates new expense
  def track_receipt
    data = parse_params(params)
    save_expense(data)
    render :text => "ok"
  end
  
private
  
  # deserializes data we got from Venmo
  def parse_params(params)
    # get serialized hash from params
    data = params.select {|k,v| k.to_s.include? "payment"}
    data = data.first.last.keys.first.dup
    
    # remove malformed parameter that JSON chokes on
    data = data.gsub(/\"img_url.*?, /m, "")
    
    # parse JSON
    data = JSON.parse data
    Rails.logger.info "parsed hash from API: #{data.inspect}"
    
    return data
  end

end
