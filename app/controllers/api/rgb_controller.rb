module Api

  class RgbController < Api::BaseController

    # /api/rgb?date=01.10.2015
    # /api/rgb?from=01.10.2015&to=04.10.2015
    # @returns {
    #           data: [ {date: "01.10.2015",
    #                   rgb: [[1,2,3],[4,5,6], ..., [100,222, 123]] },  # 24x
    #                  {date: "02.10.2015",
    #                   rgb: [ <24 rgb-arrays> ] },
    #                   {date: "03.10.2015",}
    #                    rgb: [ <24 rgb-arrays> ] },
    #                   {date: "04.10.2015",}
    #                    rgb: [ <24 rgb-arrays> ] },
    #                ]
    #           }
    def index
      begin
        from, to = get_request_params
        data = Rgb.from_to(from, to)
        render json: { from: from.strftime('%d.%m.%Y'),
                       to:   to.strftime('%d.%m.%Y'),
                       rgb:  data.map( &:to_arr) },
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
