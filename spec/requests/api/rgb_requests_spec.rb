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
          expect( json['data'] ).to eq []
        end
      end

      context 'Data available for requested date' do

        before :each do
          FactoryGirl.create :rgb, created_at: 5.days.ago
          @rgb1 = FactoryGirl.create :rgb, created_at: 74.hours.ago
          @rgb2 = FactoryGirl.create :rgb, created_at: 77.hours.ago
          FactoryGirl.create :rgb, created_at: 1.days.ago
        end

        let(:requested_date) { 3.days.ago.strftime('%d.%m.%Y') }

        it "returns the json with 'data' array for requested day" do
          do_get
          json = json_response
          expect( json['data'].count ).to eq 1
          expect( Date.parse(json['data'].first['day']) ).to eq Date.parse requested_date
          expect( json['data'].first['rgb'].count ).to eq 2
          expect( json['data'].first['rgb'] ).to match_array [@rgb1.to_arr, @rgb2.to_arr]
        end
      end
    end

    context 'evil input' do
      let(:requested_date) { 'delete from rgbs' }

      it 'returns status 400' do
        do_get
        expect(response.status).to eq 400
      end
    end

    describe 'Request with from and to date' do
      let(:url) { "/api/rgb?from=#{from_date}&to=#{to_date}" }

      let(:from_date) { 3.days.ago.strftime('%d.%m.%Y') }
      let(:to_date)   { 2.days.ago.strftime('%d.%m.%Y') }

      before :each do
        FactoryGirl.create :rgb, created_at: 8.days.ago
        @rgb1 = FactoryGirl.create :rgb, created_at: 90.hours.ago
        @rgb2 = FactoryGirl.create :rgb, created_at: 80.hours.ago
        @rgb3 = FactoryGirl.create :rgb, created_at: 60.hours.ago
        @rgb4 = FactoryGirl.create :rgb, created_at: 50.hours.ago
        FactoryGirl.create :rgb, created_at: 1.days.ago
      end

      it "returns the json with 'data' array for requested day" do
        do_get
        json = json_response

        expect( Date.parse(json['from']) ).to eq Date.parse from_date
        expect( Date.parse(json['to'])   ).to eq Date.parse to_date

        expect( json['data'].count ).to eq 2
        expect( Date.parse(json['data'].first['day']) ).to eq Date.parse from_date
        expect( Date.parse(json['data'].last['day'])  ).to eq Date.parse to_date

        expect( json['data'].first['rgb'].count ).to eq 2
        expect( json['data'].first['rgb'] ).to match_array [@rgb1.to_arr, @rgb2.to_arr]

        expect( json['data'].last['rgb'].count ).to eq 2
        expect( json['data'].last['rgb'] ).to match_array [@rgb3.to_arr, @rgb4.to_arr]

      end

    end
  end

end

