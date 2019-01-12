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
every 1.day, at: '20:15' do
  command 'bundle exec pry app/avito_scraper.rb send_report'
end

every 12.hours, at: '00:00' do
  command 'bundle exec pry app/avito_scraper.rb sync'
end

# Learn more: http://github.com/javan/whenever
