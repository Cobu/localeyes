class ZipCode < ActiveRecord::Base
  scope :search, ->(term) { where("zip_code LIKE :term or city like :term or state like :term or state_short like :term", :term=> "%#{term}%") }

  def as_json(options={})
    {:label=> "#{city}, #{state_short} #{zip_code}", :zip_code=> zip_code, :type=>:z, id: id}
  end

  def self.get_center_info(id)
    zip = find(id) rescue nil
    zip.center_json if zip
  end

  def center_json
    {:title=> "#{city}, #{state_short}, #{zip_code}", :lat=>lat, lng: lng}
  end
end
