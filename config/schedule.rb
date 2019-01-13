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
every 1.day, at: ['2:00', '5:00'] do
  command 'cd /code/avito_scraper/current && bundle exec pry app/avito_scraper.rb sync'
end

every 1.day, at: '08:00' do
  command 'cd /code/avito_scraper/current && bundle exec pry app/avito_scraper.rb send_report'
end

# Learn more: http://github.com/javan/whenever
