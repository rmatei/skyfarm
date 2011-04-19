class TalliedConsumption < ActiveRecord::Base
  belongs_to :user
  belongs_to :tallied_item
  belongs_to :billing_period
  
  validates_presence_of :user
  validates_presence_of :tallied_item
  
  def to_label
    bp = billing_period ? " (#{billing_period.to_label})" : ""
    "#{user.short_name} - #{tallied_item.name}" + bp
  end
  
  def cost
    tallied_item.price * number
  end
  
end
