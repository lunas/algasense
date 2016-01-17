module Api

  class RgbController < Api::BaseController

    # /api/rgb?date=01.10.2015
    # /api/rgb?from=04.01.2016&to=05.01.2016
    # @returns { "from":"05.01.2016",
    #            "to":"06.01.2016",
    #            "data":[{"day":"2016-01-05","rgb":[[121,142,159],[138,11,133],...]}, # (24 x array of 3 rgb-values)
    #                    {"day":"2016-01-06","rgb":[[123,222,111],[21,122,288],...]}   # (24 x array of 3 rgb-values)
    #          }
    def index
      begin
        from, to = get_request_params
        data = Rgb.from_to(from, to)
        render json: { from: from.strftime('%d.%m.%Y'),
                       to:   to.strftime('%d.%m.%Y'),
                       data: data },
               status: 200
      rescue ArgumentError => e
        render json: { error: e.message }, status: 400 # bad request
      end
    end


    private

    def get_request_params
      date = params['date']
      if date
        from_date = Date.parse(date)
        [from_date, from_date]
      else
        from = params['from']
        to   = params['to']
        if from && to
          from_date = Date.parse(from)
          to_date   = Date.parse(to)
          [from_date, to_date]
        else
          raise ArgumentError.new("Missing from-date or to-date!")
        end
      end
    end
  end

end
