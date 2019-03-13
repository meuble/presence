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
    end
    
    describe "name" do
      it "should be present" do
        @user.name = nil
        expect(@user.save).to be_falsy
        expect(@user.errors).to include(:name)
      end
    end
  end
end
