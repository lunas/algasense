require "serialport"
require "data_source_factory"
require 'Logger'

# Reads the data stream from the serial port (as configured in Rails.configuration),
# then notifies its observers each time something is read from the serial port.
# Also logs read data to a log file.
class SerialReader

  def self.read
    @reader = DataSourceFactory.create
    @reader.read
  end

  def self.shutdown
    @reader.close_serial_port if @reader
  end

  # @param read_interval: Time to wait for the next reading of the sensor, in second
  def initialize(read_interval, logger = nil)
    @serial_port = DataSourceFactory.create
    @logger = logger ? logger : Logger.new( config[:logger] )
    @observers = []
    @read_interval = read_interval
    @last_read = Time.now
  end


  def add_observer(observer)
    @observers << observer
  end


  def notify(data)
    @observers.each { |obs| obs.update data }
  end


  def read
    #just read forever
    begin
      while true do
        while (data = @serial_port.gets.chomp) do
          if time_ripe?
            notify data
            @logger.info data
            @last_read = Time.now
          end
        end
      end
    rescue StandardError => e
      @logger.error e.message
    ensure
      close_serial_port unless @serial_port.closed?
    end
  end


  def close_serial_port
    @serial_port.close
  end


  def time_ripe?
    Time.now - @last_read > @read_interval
  end

end


# Signal.trap("INT") {
#   SerialReader.shutdown
# }
# Signal.trap('TERM'){
#   SerialReader.shutdown
# }
#
# SerialReader.read