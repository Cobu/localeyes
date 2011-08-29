class User < ActiveRecord::Base
  has_secure_password

  validates :email, :presence => true
  validates :email, :uniqueness => true, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}, :allow_nil => true
  validates :password, :confirmation => true, :on=>:create, :length => {:minimum => 6}

  def self.authenticate(email,password)
    find_by_email(email).try(:authenticate, password)
  end
end