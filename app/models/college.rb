class College < ActiveRecord::Base
  scope :search, ->(term) { where("name LIKE :term", :term=> "%#{term}%") }

  geocoded_by :full_address, :latitude => :lat, :longitude => :lng
  before_create :geocode

  def full_address
    [address, city, state_short, zip_code].compact.join(' ')
  end

  def center_json
    {title: "#{name}\n#{city}, #{state_short}, #{zip_code}", lat: lat, lng: lng}
  end
end