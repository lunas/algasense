require "serialport"
require 'Logger'

# Reads the data stream from the serial port (as configured in Rails.configuration),
# then notifies its observers each time something is read from the serial port.
# Also logs read data to a log file.
class SerialReader

  def self.read
    @reader = SerialReader.new
    @reader.read
  end

  def self.shutdown
    @reader.close_serial_port if @reader
  end

  def initialize(logger = nil)
    @port_str  = config[:port_str]
    @baud_rate = config[:baud_rate]
    @data_bits = 8
    @stop_bits = 1
    @parity    = SerialPort::NONE
    @serial_port = SerialPort.new @port_str, @baud_rate, @data_bits, @stop_bits, @parity

    @logger = logger ? logger : Logger.new( config[:logger] )
    @observers = []
  end


  def add_observer(observer)
    @observers << observer
  end


  def notify(data)
    @observers.each {|obs| obs.update data }
  end


  def read
    #just read forever
    begin
      while true do
        while (data = @serial_port.gets.chomp) do
          notify data
          @logger.info data
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

  private

  def config
    begin
      {port_str:  Rails.configuration.x.port_str,
       baud_rate: Rails.configuration.x.baud_rate,
       logger:    Rails.configuration.x.serial_log_file
      }
    rescue StandardError
      {port_str:  '/dev/tty.usbmodem1b11',
       baud_rate: 38400,
       logger:    File.join(File.dirname(__FILE__), '..', 'log', 'serial.log')
      }
    end
  end
end


Signal.trap("INT") {
  SerialReader.shutdown
}
Signal.trap('TERM'){
  SerialReader.shutdown
}

SerialReader.read