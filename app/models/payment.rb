class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :billing_period
  validates_presence_of :amount, :user
  validates_uniqueness_of :billing_period_id, :scope => :user_id
  serialize :details

  scope :paid, where(:paid => true)
  scope :unpaid, where(:paid => false)
  
  def log
    puts "\n#{user.full_name}  =>  #{amount.round(2)}"
    details.each do |category|
      puts "  #{category[:amount].round(2)} - #{category[:category]}"
      category[:details].each do |expense|
        puts "    #{expense[:amount].round(2)} - #{expense[:note].strip}"
      end
    end
    puts "\n"
  end
  
  def to_label
    "$#{amount.round(2)}"
  end
  
  # sends an email requesting payment
  def request
    puts "emailing #{user.email} for payment..."
    Notifier.bill(self).deliver
    update_attribute :sent_request, true
  end
  
end
