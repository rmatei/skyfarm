module UsersHelper
  
  def profile_picture_column(record)
    "<img src='#{record.profile_picture}' />"
  end
  
  def monthly_rent_column(record)
    number_to_currency record.monthly_rent, :precision => 0 
  end
  
end
