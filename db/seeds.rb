require 'factory_girl_rails'

unless Rails.env.production?
  BusinessUser.destroy_all
  Business.destroy_all
  User.destroy_all
  ZipCode.connection.execute "TRUNCATE `zip_codes`"
  College.connection.execute "TRUNCATE `colleges`"

  bu = FactoryGirl.create(:business_user, :email=>"dude@dude.com")
  cafe = FactoryGirl.build(:oswego_cafe, :user=> bu)
  cafe.set_default_hours
  cafe.save
  resto = FactoryGirl.build(:oswego_restaurant, :user=> bu)
  resto.set_default_hours
  resto.save

  FactoryGirl.create(:dude)

  now = Time.now.utc
  FactoryGirl.create(:once_event, :business=>cafe, :start_time => Time.utc(2011, now.month, 3, 21, 10), :end_time => Time.utc(2011, now.month, 4, 2, 30), :title=>"one times")
  FactoryGirl.create(:daily_event, :business=>cafe, :start_time => Time.utc(2011, now.month, 5, 10, 15), :end_time => Time.utc(2011, now.month, 5, 22, 0), :title=>"whole day fiesta")
  FactoryGirl.create(:weekly_event, :business=>cafe, :start_time => Time.utc(2011, now.month, 6, 21, 30), :end_time => Time.utc(2011, now.month, 7, 1, 50), :title=>"bubbly times")

  FactoryGirl.create(:once_event, :business=>resto, :start_time => Time.utc(2011, now.month, 4, 20, 5), :end_time => Time.utc(2011, now.month, 4, 2, 30), :title=>"one times special")
  FactoryGirl.create(:daily_event, :business=>resto, :start_time => Time.utc(2011, now.month, 1, 19, 45), :end_time => Time.utc(2011, now.month, 1, 21, 45), :title=>"happy hour", :event_type=> Event::SPECIAL)
end

FactoryGirl.create(:oswego)
FactoryGirl.create(:new_paltz)
FactoryGirl.create(:ithaca)
FactoryGirl.create(:suny_new_paltz)
FactoryGirl.create(:suny_oswego)
FactoryGirl.create(:ithaca_college)
FactoryGirl.create(:cornell)

