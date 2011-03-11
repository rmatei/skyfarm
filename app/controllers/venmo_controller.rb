class VenmoController < ApplicationController

  # takes Venmo API call, creates new expense
  def track_receipt
    logger.error "logger working"
    Rails.logger.error "Rails logger working"
    
    # extracts serialized string from parameters
    data = params.select {|k,v| k.to_s.include? "payment"}
    data = data.first.last.keys.first.dup
    
    # remove malformed parameter that JSON chokes on
    data = data.gsub(/\"img_url.*?, /m, "")
    
    # parse JSON
    data = JSON.parse data
    logger.info "parsed hash from API: #{data.inspect}"
    
    render :text => "ok"
  end

end
