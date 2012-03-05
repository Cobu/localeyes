class ZipCodeDecorator < ApplicationDecorator
  include ActiveModel::Serializers::JSON
  self.include_root_in_json = false

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
end