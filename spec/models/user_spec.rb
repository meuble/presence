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
end
