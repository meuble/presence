require 'rails_helper'

RSpec.describe Api::V1::LinesController, type: :controller do
  describe "#index" do
    it "should render json" do
      get :index
      expect(response.header['Content-Type']).to include('application/json')
    end

    describe "with lines" do
      it "should list all lines" do
        lines = (1..10).to_a.map {|i| create(:line) }
        get :index
        expect(response.body).to eq(lines.to_json)
      end
    end
    
    describe "without lines" do
      it "should list no lines" do
        get :index
        expect(response.body).to eq([].to_json)
      end
    end
  end
end
