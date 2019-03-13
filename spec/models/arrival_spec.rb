require 'rails_helper'

RSpec.describe Arrival, type: :model do
  describe "Attributes" do
    it "should have a electricity_metric" do
      expect(Arrival.new).to respond_to(:electricity_metric)
      expect(Arrival.new.attributes.keys).to include("electricity_metric")
    end

    it "should have an water_metric" do
      expect(Arrival.new).to respond_to(:water_metric)
      expect(Arrival.new.attributes.keys).to include("water_metric")
    end
    
    it "should have an apply date" do
      expect(Arrival.new).to respond_to(:applies_on)
      expect(Arrival.new.attributes.keys).to include("applies_on")
    end
  end

  describe "Validations" do
    before :each do
      @arrival = build(:arrival)
    end
    
    it "should correctly save valid arrival" do
      expect(@arrival.save).to be_truthy
      expect(@arrival.persisted?).to be_truthy
    end
    
    describe "electricity_metric" do
      it "should be present" do
        @arrival.electricity_metric = nil
        expect(@arrival.save).to be_falsy
        expect(@arrival.errors).to include(:electricity_metric)
      end
    end
    
    describe "water_metric" do
      it "should be present" do
        @arrival.water_metric = nil
        expect(@arrival.save).to be_falsy
        expect(@arrival.errors).to include(:water_metric)
      end
    end
  end

  describe "Relations" do
    it "should belongs to a user" do
      @arrival = build(:arrival, user_id: nil)
      expect(@arrival).to respond_to(:user)
      expect(@arrival.user).to be_nil
      
      user = create(:user)
      @arrival.user_id = user.id
      @arrival.save
      expect(@arrival.reload.user).to eq(user)
    end
  end
end
