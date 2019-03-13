require 'rails_helper'

RSpec.describe Line, type: :model do
  describe "Attributes" do
    it "should have a electricity_metric" do
      expect(Line.new).to respond_to(:electricity_metric)
      expect(Line.new.attributes.keys).to include("electricity_metric")
    end

    it "should have an water_metric" do
      expect(Line.new).to respond_to(:water_metric)
      expect(Line.new.attributes.keys).to include("water_metric")
    end
    
    it "should have an apply date" do
      expect(Line.new).to respond_to(:applies_on)
      expect(Line.new.attributes.keys).to include("applies_on")
    end
  end

  describe "Validations" do
    before :each do
      @line = build(:line)
    end
    
    it "should correctly save valid line" do
      expect(@line.save).to be_truthy
      expect(@line.persisted?).to be_truthy
    end
    
    describe "electricity_metric" do
      it "should be present" do
        @line.electricity_metric = nil
        expect(@line.save).to be_falsy
        expect(@line.errors).to include(:electricity_metric)
      end
    end
    
    describe "water_metric" do
      it "should be present" do
        @line.water_metric = nil
        expect(@line.save).to be_falsy
        expect(@line.errors).to include(:water_metric)
      end
    end
  end

  describe "Relations" do
    it "should belongs to a user" do
      @line = build(:line, user_id: nil)
      expect(@line).to respond_to(:user)
      expect(@line.user).to be_nil
      
      user = create(:user)
      @line.user_id = user.id
      @line.save
      expect(@line.reload.user).to eq(user)
    end
  end
end
