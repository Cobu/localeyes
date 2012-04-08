require 'spec_helper'

describe ZipCodeDecorator do
  let(:zip_code) { build(:ithaca) }
  subject{ ZipCodeDecorator.new(zip_code) }

  its(:zip_code) { should == zip_code.zip_code }
  its(:full_address){ should == "Ithaca New York 14850" }
  its(:label){ should == "Ithaca, NY 14850" }
  its(:type) { should == :z }
end