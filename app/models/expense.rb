class Expense < ActiveRecord::Base
    
  belongs_to :user
  
  # Expense types:
  # type_id 1 - general (split equally)
  # type_id 2 - food (pro-rated)
  def set_expense_type_from_venmo_name(name)
    if name.downcase.include?("expenses")
      self.type_id = 1
    elsif name.downcase.include?("food")
      self.type_id = 2
    end
  end
  
  # display note as label in scaffold
  alias_method_name :to_label, :note
  
end
