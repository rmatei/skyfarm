class User < ActiveRecord::Base
  has_many :expenses
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def total_spent
    expenses.map(&:amount).inject{|sum,x| sum + x }
  end
  
  # for Active Scaffold
  alias_method :to_label, :full_name

end
