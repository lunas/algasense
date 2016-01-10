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

      context 'No rgb data available for requested date' do
        it "returns the json with 'from', 'to', and empty 'data' array " do
          do_get
          json = json_response
          expect( json['from'] ).to eq requested_date
          expect( json['to'] ).to eq requested_date
          expect( json['rgb'] ).to eq []
        end
      end

      context 'Data available for requested date' do

        before :each do
          FactoryGirl.create :rgb, created_at: 5.days.ago
          @rgb1 = FactoryGirl.create :rgb, created_at: 3.days.ago
          @rgb2 = FactoryGirl.create :rgb, created_at: 3.days.ago
          FactoryGirl.create :rgb, created_at: 1.days.ago
        end

        let(:requested_date) { 3.days.ago.strftime('%d.%m.%Y') }

        it "returns the json with 'data' array for requested day" do
          do_get
          json = json_response
          expect( json['rgb'].count ).to eq 2
          expect( json['rgb'] ).to match_array [@rgb1.to_arr, @rgb2.to_arr]
        end
      end

    end

  end

end
