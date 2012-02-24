class ZipCode < ActiveRecord::Base
  scope :search, ->(term) { where("zip_code LIKE :term or city like :term or state like :term or state_short like :term", :term=> "%#{term}%") }

  geocoded_by :full_address, latitude: :lat, longitude: :lng

  def full_address
    [city, state, zip_code].compact.join(' ')
  end
end
