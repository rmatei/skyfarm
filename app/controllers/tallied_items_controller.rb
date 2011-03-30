class TalliedItemsController < ApplicationController

  active_scaffold :tallied_items do |config|
    # Limited column display for usability
    config.columns = [:name, :price]
  end

end
