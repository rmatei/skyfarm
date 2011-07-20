module UsersHelper
  
  def profile_picture_column(record)
    image_tag(record.profile_picture).html_safe
  end
  
  def monthly_rent_column(record)
    number_to_currency record.monthly_rent, :precision => 0 
  end
  
  def total_spent_column(record)
    number_to_currency record.total_spent
  end
  
  def food_coefficient_column(record)
    if record.food_coefficient
      number_to_percentage record.food_coefficient*100, :precision => 0 
    else
      nil
    end
  end
  
  def expenses_coefficient_column(record)
    if record.expenses_coefficient
      number_to_percentage record.expenses_coefficient*100, :precision => 0 
    else
      nil
    end
  end
  
end
