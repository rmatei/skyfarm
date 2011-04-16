class TalliedItem < ActiveRecord::Base
  has_many :tallied_consumptions
  
  def plural_name
    name.downcase.pluralize
  end
end
