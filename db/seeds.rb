require 'machinist/active_record'
require_relative '../spec/blueprints'

BusinessUser.destroy_all
User.destroy_all
ZipCode.connection.execute "TRUNCATE `zip_codes`"
Colleges.connection.execute "TRUNCATE `colleges`"

bu = BusinessUser.make(:email=>"dude@dude.com")
cafe = Business.make(:oswego_cafe, :user=> bu)
cafe.set_default_hours
cafe.save

now = Time.now.utc
Event.make(:once, :business=>cafe, :start_time => Time.utc(2011,now.month,3,21,10), :end_time => Time.utc(2011,now.month,4,2,30), :title=>"one times")
Event.make(:daily, :business=>cafe, :start_time => Time.utc(2011,now.month,5,7,30), :title=>"fun day times")
Event.make(:weekly,:business=>cafe, :start_time => Time.utc(2011,now.month,6,21,30),:end_time => Time.utc(2011,now.month,7,1,50), :title=>"bubbly times")

User.make(:nyc)

ZipCode.make(:oswego)
ZipCode.make(:new_paltz)
College.make(:suny_new_paltz)
College.make(:suny_oswego)