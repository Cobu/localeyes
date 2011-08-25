require 'machinist/active_record'
require_relative '../spec/blueprints'

Business.delete_all
Event.delete_all

cafe = Business.make(:nyc_cafe)

Event.make(:once, :business=>cafe, :start_time => Time.utc(2011,8,3,21,10), :end_time => Time.utc(2011,8,4,2,30), :title=>"one times")
#Event.make(:daily, :business=>cafe, :start_time => Time.utc(2011,8,5,7,30), :title=>"fun day times")
#Event.make(:weekly,:business=>cafe, :start_time => Time.utc(2011,8,6,21,30),:end_time => Time.utc(2011,8,7,1,50), :title=>"bubbly times")
