set :output, {:standard => "log/cron.log"}


every 1.day, at: "8:00 am" do
  runner "Event.publish"
end
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

