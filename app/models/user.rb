class User < ActiveRecord::Base
  belongs_to :college

  has_secure_password
  reset_callbacks(:validate)

  validates :email, presence: true
  validates :email, uniqueness: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}, allow_nil: true
  #validates :password, confirmation: true, on: :create, length: {minimum: 6} , if: -> {password.present?}

  attr_writer :name
  before_create :split_name

  def self.create_from_auth_info(info)

  end

  def birthday=(birthday)
    # try parsing this format ( m/d/y ) to see if it works
    date = Date.strptime birthday, '%m/%d/%Y' rescue nil
    write_attribute(:birthday, (date.to_s || birthday))
  end

  def split_name
    self.first_name, self.last_name = @name.split if @name
  end

  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end

  def add_favorite(business_id)
    EventVote.db.collection('favorites').update( {user_id: id}, {"$addToSet"=> {businesses: business_id}}, {upsert: true})
  end

  def remove_favorite(business_id)
    EventVote.db.collection('favorites').update( {user_id: id}, {'$pull'=> {businesses: business_id}}, {upsert: true})
  end

  def favorites
    EventVote.db.collection('favorites').find( {user_id: id} ).first.try(:[],'businesses')
  end
end