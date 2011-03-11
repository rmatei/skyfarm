class Expense < ActiveRecord::Base
    
  belongs_to :user
  
  # Expense types:
  # type_id 1 - general (split equally)
  # type_id 2 - food (pro-rated)
  # type_id 3 - booze (tallied, with remnant split equally)  
  def type
    case type_id
      when 1 then "general expense"
      when 2 then "food"
      when 3 then "tallied (booze & more)"
      else "unknown"
    end
  end
  
  def general?
    type_id == 1
  end
  
  def food?
    type_id == 2
  end

  def set_type_from_venmo_transaction(name)
    if note.downcase.include? "beer" or note.downcase.include? "wine"
      self.type_id = 3
    elsif name.downcase.include?("expenses")
      self.type_id = 1
    elsif name.downcase.include?("food")
      self.type_id = 2
    end
  end  
  
  def amount_per_person
    self.amount / 8
  end
  
  # display note as label in scaffold
  def to_label
    note
  end
  
end
