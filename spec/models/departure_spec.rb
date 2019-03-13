require 'rails_helper'

RSpec.describe Departure, type: :model do
  describe "Attributes" do
    it "should have a electricity_metric" do
      expect(Departure.new).to respond_to(:electricity_metric)
      expect(Departure.new.attributes.keys).to include("electricity_metric")
    end

    it "should have an water_metric" do
      expect(Departure.new).to respond_to(:water_metric)
      expect(Departure.new.attributes.keys).to include("water_metric")
    end
    
    it "should have an apply date" do
      expect(Departure.new).to respond_to(:applies_on)
      expect(Departure.new.attributes.keys).to include("applies_on")
    end
  end

  describe "Validations" do
    before :each do
      @departure = build(:departure)
    end
    
    it "should correctly save valid departure" do
      expect(@departure.save).to be_truthy
      expect(@departure.persisted?).to be_truthy
    end
    
    describe "electricity_metric" do
      it "should be present" do
        @departure.electricity_metric = nil
        expect(@departure.save).to be_falsy
        expect(@departure.errors).to include(:electricity_metric)
      end
    end
    
    describe "water_metric" do
      it "should be present" do
        @departure.water_metric = nil
        expect(@departure.save).to be_falsy
        expect(@departure.errors).to include(:water_metric)
      end
    end
  end

  describe "Relations" do
    it "should belongs to a user" do
      @departure = build(:departure, user_id: nil)
      expect(@departure).to respond_to(:user)
      expect(@departure.user).to be_nil
      
      user = create(:user)
      @departure.user_id = user.id
      @departure.save
      expect(@departure.reload.user).to eq(user)
    end
  end
end
