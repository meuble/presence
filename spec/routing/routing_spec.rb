require 'rails_helper'

RSpec.describe Arrival, type: :routing do
  describe "API" do
    describe "v1" do
      it "should route to lines#index" do
        expect(get: "/api/v1/lines").to route_to(
          controller: "api/v1/lines",
          action: "index"
        )
      end
    end
  end
end