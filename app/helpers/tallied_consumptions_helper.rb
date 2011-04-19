module TalliedConsumptionsHelper
  
  def cost_column(record)
    number_to_currency record.cost
  end
  
end
