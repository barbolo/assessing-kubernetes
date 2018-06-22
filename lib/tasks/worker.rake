namespace :worker do
  desc 'Run the worker'
  task :run => :environment do
    hostname = `hostname`
    while true
      BackgroundJob.create(hostname: hostname)
      puts "#{hostname}: created a new BackgroundJob"
      sleep 1
    end
  end
end
