class Business < ActiveRecord::Base
  has_many :events, :dependent => :destroy

  CAFE = 0
  RESTAURANT = 1
  BAR = 2
end