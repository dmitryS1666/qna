set :chronic_options, hours24: true

every 1.day, at: '20:00' do
  runner "DigestDispatchJob.create"
end

every 15.minutes do
  rake "thinking_sphinx:index"
end

every :reboot do
  rake "thinking_sphinx:start"
end