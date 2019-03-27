require 'rails_helper'

class DummyExceptionHandlerController < ActionController::Base
  include ExceptionHandler
end

describe DummyExceptionHandlerController, type: :controller do
  describe "On error" do
    controller(DummyAuthenticableController) do
      def index
        raise FiberError.new("Sample message")
      end
    end
    
    it "should catch all error" do
      expect do
        get :index
      end.not_to raise_error
    end
    
    it "should render internal error status" do
      get :index
      expect(response).to have_http_status(:internal_server_error)
    end

    it "should render json with message" do
      get :index
      expect(JSON.parse(response.body)["message"]).to eq("Sample message")
    end

    it "should render json with error type" do
      get :index
      expect(JSON.parse(response.body)["type"]).to eq("FiberError")
    end
  end

  describe "On RecordNotFound error" do
    controller(DummyAuthenticableController) do
      def index
        raise ActiveRecord::RecordNotFound.new("Sample message")
      end
    end
    
    it "should catch all error" do
      expect do
        get :index
      end.not_to raise_error
    end
    
    it "should render internal error status" do
      get :index
      expect(response).to have_http_status(:not_found)
    end

    it "should render json with message" do
      get :index
      expect(JSON.parse(response.body)["message"]).to eq("Sample message")
    end

    it "should render json with error type" do
      get :index
      expect(JSON.parse(response.body)["type"]).to eq("ActiveRecord::RecordNotFound")
    end
  end

  describe "On RecordInvalid error" do
    controller(DummyAuthenticableController) do
      def index
        raise ActiveRecord::RecordInvalid
      end
    end
    
    it "should catch all error" do
      expect do
        get :index
      end.not_to raise_error
    end
    
    it "should render internal error status" do
      get :index
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should render json with message" do
      get :index
      expect(JSON.parse(response.body)["message"]).to eq("Record invalid")
    end

    it "should render json with error type" do
      get :index
      expect(JSON.parse(response.body)["type"]).to eq("ActiveRecord::RecordInvalid")
    end
  end

  describe "On JWT::DecodeError error" do
    controller(DummyAuthenticableController) do
      def index
        raise JWT::DecodeError.new("Sample message")
      end
    end
    
    it "should catch all error" do
      expect do
        get :index
      end.not_to raise_error
    end
    
    it "should render internal error status" do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it "should render json with message" do
      get :index
      expect(JSON.parse(response.body)["message"]).to eq("Sample message")
    end

    it "should render json with error type" do
      get :index
      expect(JSON.parse(response.body)["type"]).to eq("JWT::DecodeError")
    end
  end

  describe "On JWT::ExpiredSignature error" do
    controller(DummyAuthenticableController) do
      def index
        raise JWT::ExpiredSignature.new("Sample message")
      end
    end
    
    it "should catch all error" do
      expect do
        get :index
      end.not_to raise_error
    end
    
    it "should render internal error status" do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it "should render json with message" do
      get :index
      expect(JSON.parse(response.body)["message"]).to eq("Sample message")
    end

    it "should render json with error type" do
      get :index
      expect(JSON.parse(response.body)["type"]).to eq("JWT::ExpiredSignature")
    end
  end
end