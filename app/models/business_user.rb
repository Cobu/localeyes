class BusinessUser < User
  has_many :businesses, :foreign_key => :user_id, :dependent => :destroy

  has_secure_password

  def self.authenticate(email,password)
    find_by_email(email).try(:authenticate, password)
  end
end