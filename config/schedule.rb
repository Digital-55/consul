# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
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

# Learn more: http://github.com/javan/whenever

every 1.minute do
  command "date > ~/cron-test.txt"
end

every 1.day, at: "5:00 am" do
  rake "-s sitemap:refresh"
end

every 1.day do
  rake "-s budgets:stats:balloting"
end

every 2.hours do
  rake "-s stats:generate"
end

every 1.day, at: "4:00 am", roles: [:cron] do
  rake "csv:export"
end

# Temporally not send dashboard's notifications
# every 1.day, at: "7:00 am" do
#   rake "dashboards:send_notifications"
# end

every 1.day, at: "3:00 am", roles: [:cron] do
  rake "votes:reset_hot_score"
end

every 1.day, at: "2:00 am", roles: [:cron] do
  rake "padron:update"
end
