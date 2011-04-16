class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :billing_period
  validates_presence_of :amount, :user
  validates_uniqueness_of :billing_period_id, :scope => :user_id
  serialize :details
  
  def log
    puts "#{user.full_name}  =>  #{amount.round(2)}"
    details.each do |category|
      # items = category[:details].first(4).map {|e| e[:note].strip}.join(', ')
      puts "  #{category[:amount].round(2)} - #{category[:category]}"
      category[:details].first(4).each do |expense|
        puts "    #{expense[:amount].round(2)} - #{expense[:note].strip}"
        # puts "     - #{expense[:note].strip}"
      end
      # puts "    ..."
    end
    puts "\n"
  end
end
