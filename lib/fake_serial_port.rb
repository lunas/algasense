class FakeSerialPort

  attr :open

  def initialize
    @open = true
  end


  def gets
    sleep 1           # waitasecond
    "66, 77, 88\n"
  end


  def closed?
    !@open
  end


  def close
    @open = false
  end
end