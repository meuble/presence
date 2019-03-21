require 'rails_helper'

RSpec.describe Api::V1::LinesController, type: :controller do
  render_views

  describe "#index" do
    it "should render json" do
      get :index, format: :json
      expect(response.header['Content-Type']).to include('application/json')
    end

    describe "with no authenticated users" do
      it "should not list line"
    end
    
    describe "with lines" do
      before :each do
        @lines = (1..10).to_a.map {|i| create(:line) }
      end

      it "should list all lines" do
        get :index, format: :json
        expect(assigns(:lines)).to eq(@lines)
      end

      it "should list all lines id" do
        get :index, format: :json
        expect(JSON.parse(response.body).map {|l| l["id"]}).to eq(@lines.map(&:id))
      end

      it "should list all lines type" do
        get :index, format: :json
        expect(JSON.parse(response.body).map {|l| l["type"]}).to eq(@lines.map(&:type))
      end
      
      it "should list all electricity metrics" do
        get :index, format: :json
        expect(JSON.parse(response.body).map {|l| l["electricity_metric"]}).to eq(@lines.map(&:electricity_metric))
      end

      it "should list all water metrics" do
        get :index, format: :json
        expect(JSON.parse(response.body).map {|l| l["water_metric"]}).to eq(@lines.map(&:water_metric))
      end

      it "should list all application date" do
        get :index, format: :json
        expect(JSON.parse(response.body).map {|l| l["applies_on"]}).to eq(@lines.map{|l| l.applies_on.strftime("%F")})
      end

      it "should list all users names" do
        get :index, format: :json
        expect(JSON.parse(response.body).map {|l| l["user"]["name"]}).to eq(@lines.map{|l| l.user.name })
      end

      it "should list all users emails" do
        get :index, format: :json
        expect(JSON.parse(response.body).map {|l| l["user"]["email"]}).to eq(@lines.map{|l| l.user.email })
      end

      it "should list all users id" do
        get :index, format: :json
        expect(JSON.parse(response.body).map {|l| l["user"]["id"]}).to eq(@lines.map{|l| l.user.id })
      end

      it "should not list all created date" do
        get :index, format: :json
        expect(JSON.parse(response.body).map {|l| l["created_at"]}).to eq([nil] * @lines.count)
      end

      it "should not list all updated date" do
        get :index, format: :json
        expect(JSON.parse(response.body).map {|l| l["updated_at"]}).to eq([nil] * @lines.count)
      end

      it "should render 200 status" do
        get :index, format: :json
        expect(response).to have_http_status(200)
      end
    end
    
    describe "without lines" do
      it "should list no lines" do
        get :index, format: :json
        expect(response.body).to eq([].to_json)
      end

      it "should render 200 status" do
        get :index, format: :json
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "#create" do
    it "should render json" do
      post :create, format: :json
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
          post :create, params: @line_attributes, format: :json
        end.to change(Line, :count).by(1)
      end
      
      it "should create the new line with correct data" do
        post :create, params: @line_attributes, format: :json
        expect(assigns(:line).applies_on.strftime("%F")).to eq(@line_attributes[:applies_on])
        expect(assigns(:line).electricity_metric).to eq(@line_attributes[:electricity_metric])
        expect(assigns(:line).water_metric).to eq(@line_attributes[:water_metric])
      end
      
      it "should render newly created line" do
        post :create, params: @line_attributes, format: :json
        new_line = JSON.parse(response.body)
        expect(new_line["applies_on"]).to eq(@line_attributes[:applies_on])
        expect(new_line["electricity_metric"]).to eq(@line_attributes[:electricity_metric])
        expect(new_line["water_metric"]).to eq(@line_attributes[:water_metric])
      end
      
      it "should render 201 status" do
        post :create, params: @line_attributes, format: :json
        expect(response).to have_http_status(201)
      end
    end
    
    describe "with invalid parameters" do
      it "should create no line" do
        expect do
          post :create, format: :json
        end.not_to change(Line, :count)
      end
      
      it "should render error" do
        post :create, format: :json
        expect(JSON.parse(response.body)).to include("errors")
      end
      
      it "should render 400" do
        post :create, format: :json
        expect(response).to have_http_status(400)
      end
    end
  end
end
