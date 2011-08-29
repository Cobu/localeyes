class BusinessUser < User
  has_many :businesses, :foreign_key => :user_id, :dependent => :destroy

  validates :first_name, :last_name, :presence => true
  validates :phone, :presence => true, :format => {:with => /^[01]?[- .]?\(?[2-9]\d{2}\)?[- .]?\d{3}[- .]?\d{4}$/}
end