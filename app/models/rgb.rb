class Rgb < ActiveRecord::Base

  # @param from [Date] date from which to return RGB data collection
  # @param to [Date] date until which to return RGB data collection
  scope :from_to, ->(from, to = from) do
    if from == to
      Rgb.where("date_trunc('day', created_at) = ?", from )
    else
      Rgb.where("created_at BETWEEN ? AND ?", from, to)
    end
  end


  def to_arr
    [red, green, blue]
  end

end
