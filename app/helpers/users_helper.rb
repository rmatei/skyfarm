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
  
  def food_multiplier_column(record)
    if record.food_multiplier
      number_to_percentage record.food_multiplier*100, :precision => 0 
    else
      nil
    end
  end
  
end
