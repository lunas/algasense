require "serial_reader"

class SerialJob < ActiveJob::Base
  queue_as :serial_reader


  def perform
    Sidekiq.logger.info("Starting SerialReader")
    SerialReader.read
    Sidekiq.logger.info("SerialReader finished")
  end


  # rescue_from(StandardError) do |error|
  #   Sidekiq.logger.error error.message
  # end

end