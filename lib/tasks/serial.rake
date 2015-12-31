namespace :serial do
  desc 'Start SerialJob in Sidekqik; it will read data from the serial port and
        write it to the serial log file and update its observers.'
  task :start do
    SerialJob.perform_later
  end
end