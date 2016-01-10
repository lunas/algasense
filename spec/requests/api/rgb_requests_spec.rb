require 'rails_helper'

RSpec.describe 'RGB API' do

  def do_get(options = {})
    get url, { :format => :json }.merge(options), {"Accept" => "application/json" }
  end

  describe 'RGB for a specific date' do

    let(:url) { "/api/rgb?date=#{requested_date}" }

    context 'Request a valid date' do
      let(:requested_date) { '01.10.2015' }

      it 'returns status 200' do
        do_get
        expect(response.status).to eq 200
      end
    end

  end

end

