class TalliedItem < ActiveRecord::Base
  has_many :tallied_consumptions
end
