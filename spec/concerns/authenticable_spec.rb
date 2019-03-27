require 'rails_helper'

class DummyAuthenticableController < ActionController::Base
  include Authenticable
end

describe DummyAuthenticableController, type: :controller do
  describe "#require_login" do
    describe "with valid token" do
      it "should set current_user" do
        user = create(:user)
        subject.params[:token] = user.auth_token
        expect(subject.require_login).to eq(user)
      end
    end

    describe "without token" do
      it "should raise missing token error" do
        expect do
          subject.require_login
        end.to raise_error(JWT::DecodeError)
      end
    end

    describe "with malformed token" do
      it "should raise JWT:DecodeError error" do
        subject.params[:token] = "1234"
        expect do
          subject.require_login
        end.to raise_error(JWT::DecodeError)
      end
    end
    
    describe "with expired token" do
      it "should raise JWT::ExpiredSignature error" do
        payload = {user_id: create(:user).id, exp: 1.hour.ago.to_i }
        hmac_secret = Rails.application.credentials.secret_key_base
        token = JWT.encode payload, hmac_secret, 'HS256'
        subject.params[:token] = token
        expect do
          subject.require_login
        end.to raise_error(JWT::ExpiredSignature)
      end
    end
  end

  describe "#token" do
    it "should find the token in params" do
      subject.params[:token] = "1234"
      expect(subject.token).to eq("1234")
    end
    
    it "should find the token in authorisation header" do
      subject.request = double()
      allow(subject.request).to receive(:headers).and_return({"Authorization" => "Bearer 1234"})
      expect(subject.token).to eq("1234")
    end

    it "should find the token in an HTTPOnly cookie" do
      stub_cookie_jar = double()
      allow(stub_cookie_jar).to receive(:signed).and_return(HashWithIndifferentAccess.new)
      stub_cookie_jar.signed[:jwt] = "1234"
      allow(subject).to receive(:cookies).and_return(stub_cookie_jar)
      
      expect(subject.token).to eq("1234")
    end
  end
  
  describe "#token_from_request_headers" do
    it "should return content of authorisation header if present" do
      subject.request = double()
      allow(subject.request).to receive(:headers).and_return({"Authorization" => "Bearer 1234"})
      expect(subject.token_from_request_headers).to eq("1234")
    end
    
    it "should return nil with no authorisation header" do
      expect(subject.token_from_request_headers).to be_nil
    end
  end
  
  describe "#current_user" do
    describe "with auth token" do
      before :each do
        @user = create(:user)
        subject.params[:token] = @user.auth_token
      end

      describe "and no user" do
        it "should return nil" do
          @user.destroy
          expect(subject.current_user).to be_nil
        end
      end

      describe "and valid user" do
        it "should return authenticated user" do
          expect(subject.current_user).to eq(@user)
        end

        it "should not call JWT multiple times" do
          jwt_lib = class_double("JWT").as_stubbed_const(:transfer_nested_constants => true)
          expect(jwt_lib).to receive(:decode).and_return([{"user_id" => @user.id, exp: 1.hour.ago.to_i }, {}]).exactly(:once)
          subject.current_user
          subject.current_user
        end
      end
    end

    describe "with no auth token" do
      it "should return nil" do
        expect(subject.current_user).to be_nil
      end
    end

    describe "with expired auth token" do
      it "should return nil" do
        payload = {user_id: create(:user).id, exp: 1.hour.ago.to_i }
        hmac_secret = Rails.application.credentials.secret_key_base
        token = JWT.encode payload, hmac_secret, 'HS256'
        
        subject.params[:token] = token
        expect(subject.current_user).to be_nil
      end
    end
  end

  describe "in action" do
    describe "none mandatory current_user" do
      controller(DummyAuthenticableController) do
        def index
          if current_user
            head :ok
          else
            head :not_found
          end
        end
      end
      
      before :each do
        @user = create(:user)
        @token = @user.auth_token
      end

      it "should responds with 404 if user is not logged in" do
        get :index
        assert_response :not_found
      end

      it "should responds with 200" do
        authenticate(@token, controller)
        get :index
        assert_response :success
      end
    end
    
    describe "enforcing authentication" do
      controller(DummyAuthenticableController) do
        before_action :require_login
        
        def index
          current_user
          head :ok
        end
      end
      
      before :each do
        @user = create(:user)
        @token = @user.auth_token
      end

      it "should responds with 401 if user is not logged in" do
        get :index
        assert_response :unauthorized
      end

      it "should responds with 200 if user logged in" do
        authenticate(@token, controller)
        get :index
        assert_response :success
      end
    end
  end
end