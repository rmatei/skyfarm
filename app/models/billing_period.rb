class BillingPeriod < ActiveRecord::Base
  has_many :payments
  has_many :expenses
  has_many :tallied_consumptions
  
  validates_uniqueness_of :start_time, :scope => :end_time
  validate :end_after_start, :no_overlapping_period, :no_gap, :not_in_future
  
  
  # Run this once a month to bill everything
  def self.compute_new_period
    bp = BillingPeriod.new
    bp.initialize_date_range
    bp.save!
    bp.compute_payments
    bp.request_payments if bp.verify_amounts
  end
  
  
  # determines what range this period should cover
  def initialize_date_range
    self.start_time = if BillingPeriod.count == 0
      # first billing period: start from beginning
      Time.at(0)
    else 
      # otherwise start after last billing period
      BillingPeriod.find(:first, :order => 'end_time DESC').end_time + 1.second
    end
    self.end_time = Time.now.beginning_of_month
  end
  
  
  # figures out how much people owe and creates payment objects
  def compute_payments
    puts "Computing payments #{to_label}..."
    
    claim_expenses_for_period
    create_payments
    split_rent
    split_general_expenses
    split_food_expenses
    add_accounted_tallied_expenses
    split_unaccounted_tallied_expenses
    
    payments.each { |p| p.log }
  end
  
  
  def request_payments
    
  end
  
  
  def to_label
    "#{start_time.to_s(:short)} to #{end_time.to_s(:short)}"
  end
  
  
  # private
  
  # claim expenses and tallied consumptions for this billing period
  def claim_expenses_for_period
    Expense.update_all(["billing_period_id = ?", id], ["created_at >= ? AND created_at <= ?", start_time, end_time])
    TalliedConsumption.update_all(["billing_period_id = ?", id], ["created_at >= ? AND created_at <= ?", start_time, Time.now])#end_time])
    raise "Need to have entered alcohol consumption for the month!" unless tallied_consumptions.count >= User.count * TalliedItem.count
    puts "#{expenses.count} expenses for current billing period"
    puts "#{tallied_consumptions.count} tallied_consumptions for current billing period"
  end
  
  # makes payment objects for each user
  def create_payments
    User.all.each do |user|
      Payment.create!(:user => user, :billing_period => self, :amount => 0, :details => [])
    end
    puts "#{payments.count} payments created\n"
  end
  
  # adds rent to each payment
  def split_rent
    payments.each do |payment|
      payment.amount += payment.user.monthly_rent
      payment.details << {:category => "Rent", :amount => payment.user.monthly_rent, :details => []}
    end    
  end
  
  # adds general expenses to each payment
  def split_general_expenses
    total_general_expenses = expenses.general.map(&:amount).inject{|sum,x| sum + x }
    amount_per_person = total_general_expenses / User.count
    details = format_expenses_for_email_details(expenses.general)
    payments.each do |payment|
      payment.amount += amount_per_person
      payment.details << {:category => "General expenses", :amount => amount_per_person, :details => details}
    end
  end
  
  # adds food expenses to each payment
  def split_food_expenses
    total_food_expenses = expenses.food.map(&:amount).inject{|sum,x| sum + x }
    total_food_multiplier = User.all.map(&:food_multiplier).inject{|sum,x| sum + x }
    details = format_expenses_for_email_details(expenses.food)
    payments.each do |payment|
      amount_for_person = total_food_expenses * payment.user.food_multiplier / total_food_multiplier
      payment.amount += amount_for_person
      payment.details << {:category => "Food expenses", :amount => amount_for_person, :details => details}
    end
  end

  # add checked off beers
  def add_accounted_tallied_expenses
    @accounted_tallied_expenses = 0
    payments.each do |payment|
      details = []
      total_for_person = 0
      tallied_consumptions.find_all_by_user_id(payment.user_id).each do |consumption|
        amount_for_item = consumption.tallied_item.price * consumption.number
        payment.amount += amount_for_item
        total_for_person += amount_for_item
        details << {:amount => amount_for_item, :note => "#{consumption.number} #{consumption.tallied_item.name.downcase.pluralize}"}
      end
      payment.details << {:category => "Tallied booze", :amount => total_for_person, :details => details}
      @accounted_tallied_expenses += total_for_person
    end
  end

  # adds unaccounted tallied expenses to each payment
  def split_unaccounted_tallied_expenses
    unaccounted_tallied_expenses = expenses.tallied.map(&:amount).inject{|sum,x| sum + x } - @accounted_tallied_expenses
    amount_per_person = unaccounted_tallied_expenses / User.count
    details = format_expenses_for_email_details(expenses.tallied)
    payments.each do |payment|
      payment.amount += amount_per_person
      payment.details << {:category => "Unaccounted booze", :amount => amount_per_person, :details => details}
    end
  end
    
  # store specific expenses so people know where the money's going
  def format_expenses_for_email_details(expenses)
    returning Array.new do |array|
      expenses.sort_by {|e| e.amount}.reverse.each do |expense|
        array << {:amount => expense.amount, :note => expense.note.gsub('for ', '')}
      end
    end
  end
  
  
  
  # VALIDATIONS
  
  def verify_amounts
    false
  end

  def end_after_start
    unless end_time > start_time
      errors.add_to_base('Start time must be before end time.')
    end
  end
  
  def no_overlapping_period
    if BillingPeriod.count(:conditions => ["start_time <= ? AND end_time >= ?", end_time, start_time]) > 0
      errors.add_to_base('Can\'t have overlapping billing periods.')
    end
  end
  
  def no_gap
    if BillingPeriod.count > 0 and (BillingPeriod.find(:first, :order => 'end_time DESC').end_time + 1.second) < start_time
      errors.add_to_base('Can\'t have a gap in billing periods.')
    end
  end
  
  def not_in_future
    unless Time.now >= end_time
      errors.add_to_base('Can\'t bill into the future.')
    end
  end
  
end
