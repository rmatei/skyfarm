class User < ActiveRecord::Base
  has_many :expenses
end
