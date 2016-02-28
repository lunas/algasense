class DataSourceFactory

  def self.create
    if Rails.env.test?
      FakeSerialPort.new
    else
      port_str  = config[:port_str]
      baud_rate = config[:baud_rate]
      data_bits = config[:data_bits]
      stop_bits = config[:stop_bits]
      parity    = config[:parity]

      SerialPort.new port_str, baud_rate, data_bits, stop_bits, parity
    end
  end


  def self.config
    conf_hash = {data_bits: 8, stop_bits: 1, parity: SerialPort::NONE}
    begin
      conf_hash.merge({
                          port_str:  Rails.configuration.x.port_str,
                          baud_rate: Rails.configuration.x.baud_rate,
                          logger:    Rails.configuration.x.serial_log_file,
                          data_bits: 8,
                          stop_bits: 1,
                          parity: SerialPort::NONE
                      })
    rescue StandardError
      # If this is called from outside Rails, use this config:
      conf_hash.merge({
                          port_str:  '/dev/tty.usbmodem1b11',
                          baud_rate: 38400,
                          logger:    File.join(File.dirname(__FILE__), '..', 'log', 'serial.log'),
                      })
    end
  end

end