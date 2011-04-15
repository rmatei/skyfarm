namespace :payments  do
  desc "Tally payments at the end of the month"
  task :compute => :environment do
    Payment.destroy_all
    BillingPeriod.destroy_all
    
    BillingPeriod.compute_new_period
  end
end