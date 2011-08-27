class User < ActiveRecord::Base
  validates :email, :first_name, :last_name, :presence => true
  validates :email, :uniqueness => true, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}, :allow_nil => true
  validates :password, :confirmation => true, :on=>:create, :length => {:minimum => 6}
  validates :phone, :presence => true, :format => {:with => /^[01]?[- .]?\(?[2-9]\d{2}\)?[- .]?\d{3}[- .]?\d{4}$/}
end