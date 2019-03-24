require 'rails_helper'

RSpec.describe Api::V1::UserTokenController, type: :controller do
  describe "#create" do
    before :each do
      @password = Faker::Alphanumeric.alphanumeric(10)
      @user = create(:user, password: @password)
    end

    describe "with invalid parameters" do
      it "should responds with 404 if user does not exist" do
        post :create, params: { email: 'wrong@example.net', password: @password }, format: :json
        expect(response).to have_http_status(:not_found)
      end

      it "should responds with 401 if password is invalid" do
        post :create, params: { email: @user.email, password: 'wrong' }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
      
      it "should not send a jwt cookie" do
        post :create, params: { email: @user.email, password: 'wrong' }, format: :json
        expect(cookies.signed[:jwt]).to be_nil
      end
    end
    
    describe "with valid parameters" do
      it "sould responds with 201" do
        post :create, params: { email: @user.email, password: @password }, format: :json
        expect(response).to have_http_status(:created)
      end

      it "should send a jwt cookie" do
        post :create, params: { email: @user.email, password: @password }, format: :json
        expect(cookies.signed[:jwt]).not_to be_nil
      end
      
      it "should set the expiracy of the cookie in 1.hour" do
        stub_cookie_jar = double()
        allow(stub_cookie_jar).to receive(:signed).and_return(HashWithIndifferentAccess.new)
        allow(controller).to receive(:cookies).and_return(stub_cookie_jar)
        
        post :create, params: { email: @user.email, password: @password }, format: :json
        expiring_cookie = stub_cookie_jar.signed[:jwt]
        expect(expiring_cookie[:expires].to_i).to be_within(1).of(1.hour.from_now.to_i)
      end

      it "should send the authenticity token as a jwt token" do
        post :create, params: { email: @user.email, password: @password }, format: :json
        expect(cookies.signed[:jwt]).to eq(@user.auth_token)
      end
    end
  end
end