require 'spec_helper'

describe CollegeDecorator do
  let(:college) { build(:cornell) }
  subject{ CollegeDecorator.new(college) }

  its(:label) { should == "Cornell University Ithaca, NY 14853" }
  its(:title){ "Cornell\nUniversity Ithaca, NY 14853" }
  its(:type) { should == :c }
end