require 'machinist/active_record'
require_relative '../spec/blueprints'

BusinessUser.destroy_all

bu = BusinessUser.make(:email=>"dude@dude.com")
cafe = Business.make(:nyc_cafe, :user=> bu)

Event.make(:once, :business=>cafe, :start_time => Time.utc(2011,8,3,21,10), :end_time => Time.utc(2011,8,4,2,30), :title=>"one times")
#Event.make(:daily, :business=>cafe, :start_time => Time.utc(2011,8,5,7,30), :title=>"fun day times")
#Event.make(:weekly,:business=>cafe, :start_time => Time.utc(2011,8,6,21,30),:end_time => Time.utc(2011,8,7,1,50), :title=>"bubbly times")
