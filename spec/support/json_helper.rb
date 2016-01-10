module JsonHelper

  def json_response(key = nil)
    body = ActiveSupport::JSON.decode(response.body)
    key.present? ? body[key] : body
  end

end

RSpec.configure do |config|
  config.include JsonHelper
end
