class BusinessUser < User
  has_many :businesses, :foreign_key => :user_id, :dependent => :destroy
  has_many :authentications, :foreign_key => :user_id, :dependent => :destroy do
    def create_auth(auth)
      find_by_provider(auth['provider']) ||
      create!(provider: auth['provider'], auth_hash: auth, uid: auth['uid'])
    end
  end

  validates :first_name, :last_name, :presence => true
  #validates :phone, :presence => true, :format => {:with => /^[01]?[- .]?\(?[2-9]\d{2}\)?[- .]?\d{3}[- .]?\d{4}$/}
  validates :password, confirmation: true, on: :create, length: {minimum: 6}
end