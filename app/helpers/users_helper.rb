module UsersHelper
  
  def user_profile_picture_column(record)
    "<img src='#{record.profile_picture}' />"
  end
  
  def user_monthly_rent_column(record)
    number_to_currency record.monthly_rent
  end
  
end
