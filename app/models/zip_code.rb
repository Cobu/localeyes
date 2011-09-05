class ZipCode < ActiveRecord::Base
  scope :search, ->(term) { where("zip_code LIKE :term or city like :term", :term=> "%#{term}%") }

  def as_json(options={})
    {city: city, state_short: state_short, zip_code: zip_code}
  end
end