class Expense < ActiveRecord::Base
    
  belongs_to :user
  
  # Expense types:
  # type_id 1 - general (split equally)
  # type_id 2 - food (pro-rated)
  def type
    case type_id
      when 1 then "general expense"
      when 2 then "food"
      else "unknown"
    end
  end

  def set_type_from_venmo_name(name)
    if name.downcase.include?("expenses")
      self.type_id = 1
    elsif name.downcase.include?("food")
      self.type_id = 2
    end
  end  
  
  # display note as label in scaffold
  alias_method :to_label, :note
  
end
