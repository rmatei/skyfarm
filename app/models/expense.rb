class Expense < ActiveRecord::Base
    
  belongs_to :user
  
  # Expense types:
  # type_id 1 - general (split equally)
  # type_id 2 - food (pro-rated)
  def set_expense_type_from_venmo_name(name)
    if name.downcase.include?("food")
      self.type_id = 2
    else
      self.type_id = 1
    end
  end
  
end
