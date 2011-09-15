class IceCube::Schedule
  def self.load(str)
    return nil unless str.present?
    from_hash YAML::load(str).to_hash
  end

  def self.dump(schedule)
    schedule.to_yaml
  end
end
