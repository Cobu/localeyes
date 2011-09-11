class ZipCode < ActiveRecord::Base
  scope :search, ->(term) { where("zip_code LIKE :term or city like :term or state like :term or state_short like :term", :term=> "%#{term}%") }

  def as_json(options={})
    {:label=> "#{city}, #{state_short} #{zip_code}", :zip_code=> zip_code}
  end
end