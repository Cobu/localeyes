class College < ActiveRecord::Base
  scope :search, ->(term) { where("name LIKE :term", :term=> "%#{term}%") }

  #geocoded_by :full_address, :latitude => :lat, :longitude => :lng
  before_create :geocode

  def full_address
     [address, city, state_short, zip_code].compact.join(' ')
   end

  def as_json(options={})
    {:label=> "#{name} #{city}, #{state_short} #{zip_code}", :zip_code=> zip_code, :type=>:c, id: id}
  end

  def center_json
    {:title=> "#{name}\n#{city}, #{state_short}, #{zip_code}", :lat=>lat, lng: lng}
  end

  def self.get_center_info(id)
    find_by_id(id).try(:center_json)
  end
end