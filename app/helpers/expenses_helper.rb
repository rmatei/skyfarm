module ExpensesHelper
  
  def amount_column(record)
    number_to_currency record.amount
  end
  
  def amount_per_person_column(record)
    formatted_amount = number_to_currency(record.amount_per_person)
    record.general? ? formatted_amount : "approx. #{formatted_amount}"
  end
  
  def created_at_column(record)
    record.created_at.to_s(:long)
  end
  
end
