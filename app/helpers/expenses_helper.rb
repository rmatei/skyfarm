module ExpensesHelper
  
  def amount_column(record)
    number_to_currency record.amount
  end
  
  def amount_per_person_column(record)
    formatted_amount = number_to_currency(record.amount_per_person)
    if record.general? 
      formatted_amount
    elsif record.food? 
      "approx. #{formatted_amount}"
    else
      "by tally"
    end
  end
  
  def created_at_column(record)
    record.created_at.to_s(:long)
  end
  
end
