class CollegeDecorator < ApplicationDecorator
  include ActiveModel::Serializers::JSON
  self.include_root_in_json = false

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
end