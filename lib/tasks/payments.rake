namespace :payments  do
  desc "Tally payments at the end of the month"
  task :compute => :environment do
    BillingPeriod.compute_new_period
  end

  desc "Send emails for each payment"
  task :request => :environment do
    BillingPeriod.last.payments.each { |p| p.request }
  end
  
  desc "Send emails for each payment"
  task :request_test => :environment do
    BillingPeriod.last.payments.each { |p| p.request if p.user.last_name == "Matei" }
  end  
end