class Api::BaseController < ActionController::Base

  after_filter :cors_set_access_control_headers

  protected

  def render404(message)
    render json: {message: message}, status: 404
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def default_serializer_options
    {root: false}
  end

end
