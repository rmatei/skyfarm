class TalliedItemsController < ApplicationController

  active_scaffold :tallied_items do |config|
    # Limited column display for usability
    config.list.columns = [:name, :price , :updated_at]
  end

end
