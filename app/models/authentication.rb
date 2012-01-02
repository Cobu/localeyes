class Authentication < ActiveRecord::Base
  belongs_to :user
  scope :facebook, where(provider: :facebook)
  scope :twitter, where(provider: :twitter)
end