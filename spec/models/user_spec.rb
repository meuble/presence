require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Attributes" do
    it "should have a name" do
      expect(User.new).to respond_to(:name)
      expect(User.new.attributes.keys).to include("name")
    end

    it "should have an email" do
      expect(User.new).to respond_to(:email)
      expect(User.new.attributes.keys).to include("email")
    end

    it "should have a password digest" do
      expect(User.new).to respond_to(:password_digest)
      expect(User.new.attributes.keys).to include("password_digest")
    end
  end

  describe "Validations" do
    before :each do
      @user = build(:user)
    end
    
    it "should correctly save valid user" do
      expect(@user.save).to be_truthy
      expect(@user.persisted?).to be_truthy
    end
    
    describe "email" do
      it "should be present" do
        @user.email = nil
        expect(@user.save).to be_falsy
        expect(@user.errors).to include(:email)
      end

      it "should be formated as an email" do
        @user.email = ""
        expect(@user.save).to be_falsy
        expect(@user.errors).to include(:email)
        @user.email = "toto"
        expect(@user.save).to be_falsy
        expect(@user.errors).to include(:email)
        @user.email = "toto@localhost"
        expect(@user.save).to be_falsy
        expect(@user.errors).to include(:email)
        @user.email = "toto@zefzef.fe"
        expect(@user.save).to be_truthy
        expect(@user.errors).not_to include(:email)
      end
    end
    
    describe "name" do
      it "should be present" do
        @user.name = nil
        expect(@user.save).to be_falsy
        expect(@user.errors).to include(:name)
      end
    end

    describe "password" do
      it "should be present" do
        @user.password_digest = nil # force has_secure_password to check for a new password
        @user.password = nil
        expect(@user.save).to be_falsy
        expect(@user.errors).to include(:password)
      end
    end

    describe "password_confirmation" do
      describe "when present" do
        it "should be identic to password" do
          @user.password_digest = nil # force has_secure_password to check for a new password
          @user.password = "toto2"
          @user.password_confirmation = "toto1"
          expect(@user.save).to be_falsy
          expect(@user.errors).to include(:password_confirmation)
        end
      end
      
      describe "when absent" do
        it "should not be mandatory" do
          @user.password_digest = nil # force has_secure_password to check for a new password
          @user.password = Faker::Alphanumeric.alphanumeric(10)
          @user.password_confirmation = nil
          expect(@user.save).to be_truthy
          expect(@user.errors).not_to include(:password_confirmation)
        end
      end
    end
  end
  
  describe "Relations" do
    it "should have many lines" do
      @user = create(:user)
      expect(@user).to respond_to(:lines)
      expect(@user.lines).to eq([])
      
      line = build(:line)
      line.user_id = @user.id
      line.save
      expect(@user.reload.lines).to eq([line])
    end
  end

  describe "#auth_token" do
    before :each do
      @user = create(:user)
    end
    
    it "should use the JWT library to encode it" do
      jwt_lib = class_double("JWT").as_stubbed_const(:transfer_nested_constants => true)
      expect(jwt_lib).to receive(:encode)
      @user.auth_token
    end
    
    it "should embed the user id as payload" do
      payload = JWT.decode(@user.auth_token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' }).first
      expect(payload["user_id"]).to eq(@user.id)
    end
    
    it "should add a time stamp as payload" do
      t = Time.zone.now
      exp = 1.hour.from_now
      expect(Time.zone).to receive(:now).and_return(t)
      payload = JWT.decode(@user.auth_token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' }).first
      expect(payload["exp"]).to eq(exp.to_i)
    end

    it "should be a JWT Token" do
      token = @user.auth_token
      expect(token.split('.').size).to eq(3)
    end

    it "should expire after 1 hour" do
      token = @user.auth_token
      t = Time.zone.now
      expect(Time.zone).to receive(:now).and_return(t - 1.hours - 1.second)
      expect do
        JWT.decode(@user.auth_token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
      end.to raise_error(JWT::ExpiredSignature)
    end
    
    it "should not expire before 1 hour" do
      token = @user.auth_token
      t = Time.zone.now
      expect(Time.zone).to receive(:now).and_return(t - 30.minutes)
      expect do
        JWT.decode(@user.auth_token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
      end.not_to raise_error
    end
  end

  describe "#from_auth_token" do
    describe "with valid token" do
      it "should return corresponding user" do
        user1 = create(:user)
        user2 = create(:user)
        expect(User.from_auth_token(user1.auth_token)).to eq(user1)
        expect(User.from_auth_token(user2.auth_token)).to eq(user2)
      end
    end
    
    describe "with invalid token" do
      describe "as malformed" do
        it "should raise InvalidToken error" do
          expect do
            User.from_auth_token("1234")
          end.to raise_error(JWT::DecodeError)
        end
      end
      
      describe "as expired" do
        it "should raise InvalidToken error" do
          payload = {user_id: create(:user).id, exp: 1.hour.ago.to_i }
          hmac_secret = Rails.application.credentials.secret_key_base
          token = JWT.encode payload, hmac_secret, 'HS256'
          
          expect do
            User.from_auth_token(token)
          end.to raise_error(JWT::ExpiredSignature)
        end
      end
    end
  end
end
