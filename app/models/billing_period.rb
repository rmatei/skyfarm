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
    bp.payments.first(1).each { |payment| payment.request }
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
    verify_amounts
    
    payments.each do |p| 
      p.save!
      p.log
    end
  end
  
  
  def to_label
    "#{start_time.to_date.inspect} to #{end_time.to_date.inspect}"
  end
  

  
  private
  
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
  # these are split evenly
  def split_general_expenses
    number_of_people = User.count
    payments.each do |payment| # for each user
      details = []
      total_for_person = 0
      expenses.general.sort_by {|e| e.amount}.reverse.each do |expense| # for each expense in category
        amount_for_item = expense.amount / number_of_people
        total_for_person += amount_for_item
        details << {:amount => amount_for_item, :note => expense.note}
      end
      payment.amount += total_for_person
      payment.details << {:category => "General", :amount => total_for_person, :details => details}
    end
  end
  

  # adds food expenses to each payment
  # these are split proportionally to a food multiplier that ranges from 0 to 1
  def split_food_expenses
    total_food_multiplier = User.all.map(&:food_multiplier).inject{|sum,x| sum + x }
    payments.each do |payment| # for each user
      details = []
      total_for_person = 0
      expenses.food.sort_by {|e| e.amount}.reverse.each do |expense| # for each expense in category
        amount_for_item = expense.amount * payment.user.food_multiplier / total_food_multiplier
        total_for_person += amount_for_item
        details << {:amount => amount_for_item, :note => expense.note}
      end
      payment.amount += total_for_person
      payment.details << {:category => "Food", :amount => total_for_person, :details => details}
    end
  end


  # add checked off beers
  def add_accounted_tallied_expenses
    @accounted_tallied_expenses = 0
    payments.each do |payment|
      details = []
      total_for_person = 0
      tallied_consumptions.find_all_by_user_id(payment.user_id).sort_by {|tc| tc.number}.reverse.each do |consumption|
        amount_for_item = consumption.tallied_item.price * consumption.number
        total_for_person += amount_for_item      
        details << {:amount => amount_for_item, :note => "#{consumption.number} #{consumption.tallied_item.plural_name}"} if amount_for_item > 0
      end
      payment.details << {:category => "Tallied booze", :amount => total_for_person, :details => details}
      payment.amount += total_for_person
      @accounted_tallied_expenses += total_for_person
    end
  end


  # adds unaccounted tallied expenses to each payment
  # tallied-off ones are subtracted from purchased alcohol, rest is split evenly
  def split_unaccounted_tallied_expenses
    number_of_people = User.count
    unaccounted_ratio = 1 - (@accounted_tallied_expenses / expenses.tallied.map(&:amount).inject{|sum,x| sum + x })
    payments.each do |payment| # for each user
      details = []
      total_for_person = 0
      expenses.tallied.sort_by {|e| e.amount}.reverse.each do |expense| # for each expense in category
        amount_for_item = expense.amount * unaccounted_ratio / number_of_people
        total_for_person += amount_for_item
        details << {:amount => amount_for_item, :note => expense.note}
      end
      payment.amount += total_for_person
      # not including details for this cause they're confusing - we don't actually know what's unaccounted
      payment.details << {:category => "Unaccounted booze (very approximate)", :amount => total_for_person, :details => []}
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
  
  # sanity check
  def verify_amounts
    total_expenses = expenses.map(&:amount).inject{|sum,x| sum + x } 
    total_rent = User.all.map(&:monthly_rent).inject{|sum,x| sum + x }
    total_billed = payments.map(&:amount).inject{|sum,x| sum + x }
    puts "TOTAL BILLED: #{total_billed}"
    puts "TOTAL EXPENSES: #{total_expenses + total_rent}"
    
    # check that amounts are within $0.10 of each other (allowing for some rounding error)
    unless (total_expenses + total_rent - total_billed).abs < 0.10
      raise "Amounts to be billed don't match total expenses!"
    end
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
