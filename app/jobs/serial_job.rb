class SerialJob
  include Sidekiq::Worker

  def perform
    SerialReader.read
  end

end