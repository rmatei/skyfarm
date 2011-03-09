class VenmoController < ApplicationController

  # takes Venmo API call, creates new expense
  def track_receipt
    # extracts serialized string from parameters
    data = params.first.last.keys.first
    
    # remove malformed parameter that JSON chokes on
    clean_data = data.gsub(/\"img_url.*?, /, "").gsub(/\"img_url.*?, /, "")
    
    data = JSON.parse clean_data
    logger.info data.inspect
    
    render :text => "ok"
  end

end
