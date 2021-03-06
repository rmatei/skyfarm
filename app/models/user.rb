class User < ActiveRecord::Base
  has_many :expenses
  has_many :tallied_consumptions
  has_many :payments

  scope :active, where(:retired => false)
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  # "Richard Luke Dillman" -> "Richard"
  def short_name
    first_name.split(' ').first
  end
  
  def total_spent
    expenses.map(&:amount).inject{|sum,x| sum + x }
  end
  
  # for Active Scaffold
  alias_method :to_label, :full_name
  
end
