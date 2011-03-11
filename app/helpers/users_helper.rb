module UsersHelper
  
  def profile_picture_column(record)
    image_tag(record.profile_picture).html_safe
  end
  
  def monthly_rent_column(record)
    number_to_currency record.monthly_rent, :precision => 0 
  end
  
end
