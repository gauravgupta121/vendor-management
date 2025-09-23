# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

# Set the environment
set :environment, Rails.env

# Set the output log file
set :output, "log/cron.log"

# Define the job
every 1.day, at: "9:00 am" do
  rake "reminders:daily"
end
