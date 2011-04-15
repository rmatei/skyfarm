class TalliedConsumption < ActiveRecord::Base
  belongs_to :user
  belongs_to :tallied_item
  belongs_to :billing_period
  
  validates_presence_of :user
  validates_presence_of :tallied_item
end
