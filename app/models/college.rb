class College < ActiveRecord::Base
  scope :search, ->(term) { where("name LIKE :term", :term=> "%#{term}%") }

  def as_json(options={})
    {:label=> "#{name} #{city}, #{state_short} #{zip_code}", :zip_code=> zip_code, :type=>:c, id: id}
  end

  def center_json
    {:title=> "#{name}\n#{city}, #{state_short}, #{zip_code}", :lat=>lat, lng: lng}
  end

  def self.get_center_info(id)
    college = find(id) rescue nil
    college.center_json if college
  end
end