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

      it "should render 200 status" do
        get :index
        expect(response).to have_http_status(200)
      end
    end
    
    describe "without lines" do
      it "should list no lines" do
        get :index
        expect(response.body).to eq([].to_json)
      end

      it "should render 200 status" do
        get :index
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "#create" do
    it "should render json" do
      post :create
      expect(response.header['Content-Type']).to include('application/json')
    end
    

    describe "with no authenticated users" do
      it "should not create a line"
    end
    
    before :each do
      @user = create(:user)
    end
    describe "with valid parameters" do
      before :each do
        @line_attributes = {
          applies_on: Faker::Date.backward().strftime("%F").to_s,
          electricity_metric: Faker::Number.leading_zero_number(10),
          water_metric: Faker::Number.leading_zero_number(10)
        }
      end
      
      it "should create a new line" do
        expect do
          post :create, params: @line_attributes
        end.to change(Line, :count).by(1)
      end
      
      it "should create the new line with correct data" do
        post :create, params: @line_attributes
        expect(assigns(:line).applies_on.strftime("%F")).to eq(@line_attributes[:applies_on])
        expect(assigns(:line).electricity_metric).to eq(@line_attributes[:electricity_metric])
        expect(assigns(:line).water_metric).to eq(@line_attributes[:water_metric])
      end
      
      it "should render newly created line" do
        post :create, params: @line_attributes
        new_line = JSON.parse(response.body)
        expect(new_line["applies_on"]).to eq(@line_attributes[:applies_on])
        expect(new_line["electricity_metric"]).to eq(@line_attributes[:electricity_metric])
        expect(new_line["water_metric"]).to eq(@line_attributes[:water_metric])
      end
      
      it "should render 201 status" do
        post :create, params: @line_attributes
        expect(response).to have_http_status(201)
      end
    end
    
    describe "with invalid parameters" do
      it "should create no line" do
        expect do
          post :create
        end.not_to change(Line, :count)
      end
      
      it "should render error" do
        post :create
        expect(JSON.parse(response.body)).to include("errors")
      end
      
      it "should render 400" do
        post :create
        expect(response).to have_http_status(400)
      end
    end
  end
end
