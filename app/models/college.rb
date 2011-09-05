class College < ActiveRecord::Base
  scope :search, ->(term) { where("name LIKE :term", :term=> "%#{term}%") }

  def as_json(options={})
    {name: name, city: city, state_short: state_short, zip_code: zip_code}
  end
end