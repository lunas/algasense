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


  scope :rgb_from_to, ->(from, to = from) do
    sql = "SELECT date_trunc('day', hour) AS day, ARRAY_AGG( redgreenblue )
           FROM (
             SELECT date_trunc('HOUR', created_at) AS hour,
                    row(avg(red), avg(green), avg(blue))::rgb AS redgreenblue
             FROM rgbs
             GROUP BY hour
           ) AS hours
           WHERE date_trunc('day', hour) BETWEEN ? AND ?
           GROUP BY day
           ORDER BY day"
    Rgb.execute_sql(sql, from, to)
  end


  def self.execute_sql(*sql_array)
    connection.execute(send(:sanitize_sql_array, sql_array))
  end


  # TODO: aggregate in DB to get an array of 24 rgb-values for one day.
  # -> array of arrays.
  # Also: the individual rgb values should already be aggregates, e.g.
  #  if 24 rgb-values for a day, then each one should be an aggregate (average)
  #  of one hour!

  def to_arr
    [red, green, blue]
  end

end
