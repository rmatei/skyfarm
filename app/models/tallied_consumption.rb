class TalliedConsumption < ActiveRecord::Base
  belongs_to :user
  belongs_to :tallied_item
end
