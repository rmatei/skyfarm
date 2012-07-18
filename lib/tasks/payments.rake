namespace :payments  do
  desc "Tally payments at the end of the month"
  task :compute => :environment do
    BillingPeriod.compute_new_period
  end

  desc "Undo the last rake payments:compute"
  task :rollback => :environment do
    bp = BillingPeriod.last
    bp.expenses.each {|e| e.update_attribute :billing_period_id, nil}
    bp.tallied_consumptions.each {|e| e.update_attribute :billing_period_id, nil}
    bp.payments.each {|e| e.destroy}
    bp.destroy
  end

  desc "Send emails for each unpaid payment"
  task :request => :environment do
    BillingPeriod.last.payments.unpaid.each { |p| p.request }
  end
  
  desc "Test e-mail sending capability"
  task :request_test => :environment do
    BillingPeriod.last.payments.each { |p| p.request if p.user.last_name == "Matei" }
  end  
  
  desc "Figure out how much to pay to rent payer"
  task :rent => :environment do
    BillingPeriod.last.print_rent_payback
  end
  
end