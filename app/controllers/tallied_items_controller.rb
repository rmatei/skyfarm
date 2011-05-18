class TalliedItemsController < ApplicationController

  active_scaffold :tallied_items do |config|
    # Limited column display for usability
    config.columns = [:name, :price]

    # Don't allow any changes to DB, just reading
    config.actions = [:list, :show, :search]
  end

end
