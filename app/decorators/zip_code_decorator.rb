class ZipCodeDecorator < ApplicationDecorator
  decorates :zip_code

  # override drapers handling of zip_code to return the attribute and not the model
  def zip_code
    model.zip_code
  end

  def full_address
    [city, state, zip_code].compact.join(' ')
  end

  def label
    "#{city}, #{state_short} #{model.zip_code}"
  end
  alias :title :label

  def type
    :z
  end

  def as_json(options)
    model.as_json(options)
  end

  def center_json
    {title: title, lat: lat, lng: lng}
  end
  #def center_json
  #  {:title=> "#{city}, #{state_short}, #{zip_code}", :lat=>lat, lng: lng}
  #end
end