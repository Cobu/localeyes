class CollegeDecorator < ApplicationDecorator
  decorates :college

  def label
    "#{name} #{city}, #{state_short} #{zip_code}"
  end

  def title
    "#{name}\n#{city}, #{state_short}, #{zip_code}"
  end

  def type
    :c
  end

  def as_json(options)
    model.as_json(options)
  end

  def center_json
    {title: title, lat: lat, lng: lng}
  end
end