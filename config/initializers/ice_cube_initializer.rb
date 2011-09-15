class IceCube::Schedule
  def self.load(str)
    return nil unless str.present?
    from_yaml(str)
  end

  def self.dump(schedule)
    schedule.to_yaml
  end
end
