set :chronic_options, hours24: true

every 1.day, at: '20:00' do
  runner "DigestDispatchJob.perform_later"
end

every 60.minutes do
  rake "ts:index"
end

every :reboot do
  rake "ts:start"
end