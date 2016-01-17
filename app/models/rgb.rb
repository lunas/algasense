class Rgb < ActiveRecord::Base

  # @param from [Date] date from which to return RGB data collection
  # @param to [Date] date until which to return RGB data collection
  scope :from_to_list, ->(from, to = from) do
    if from == to
      Rgb.where("date_trunc('day', created_at) = ?", from )
    else
      Rgb.where("created_at BETWEEN ? AND ?", from, to)
    end
  end


  # @param from [Date] date from which to return RGB data collection
  # @param to [Date] date until which to return RGB data collection
  scope :from_to, ->(from, to = from) do
    sql = "SELECT date_trunc('day', hour) AS day, ARRAY_AGG( redgreenblue ) AS rgb
           FROM (
             SELECT date_trunc('HOUR', created_at) AS hour,
                    row(avg(red), avg(green), avg(blue))::rgb AS redgreenblue
             FROM rgbs
             GROUP BY hour
           ) AS hours
           WHERE date_trunc('day', hour) BETWEEN ? AND ?
           GROUP BY day
           ORDER BY day"
    results = Rgb.execute_sql(sql, from, to)
    to_hash(results)
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


  private


  def self.to_hash(pg_results)
    pg_results.inject([]) do |data, row|
      data_row = { day: row['day'].split(' ').first }
      # Split the rgb STRING into an array of arrays of floats. It has the form:
      #  {"(87.8333333333333333,135.2500000000000000,110.8333333333333333)","(135.5000000000000000,158.7500000000000000,109.6666666666666667)",...
      rgb = row['rgb']
      rgb_arr = rgb.split( ')","(')
      rgb_arr = rgb_arr.map do |elm|
        elm.gsub( /[{()}"]/, '').split(',').map do |num|
          num.to_f.round
        end
      end
      data_row[:rgb] = rgb_arr
      data << data_row
    end
  end

end
