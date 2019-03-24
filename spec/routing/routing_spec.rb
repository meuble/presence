require 'rails_helper'

RSpec.describe Arrival, type: :routing do
  describe "API" do
    describe "v1" do
      it "should route to lines#index" do
        expect(get: "/api/v1/lines.json").to route_to(
          controller: "api/v1/lines",
          action: "index",
          format: "json"
        )
      end

      it "should route to lines#create" do
        expect(post: "/api/v1/lines.json").to route_to(
          controller: "api/v1/lines",
          action: "create",
          format: "json"
        )
      end

      it "should route to user_token#create" do
        expect(post: "/api/v1/user_token.json").to route_to(
          controller: "api/v1/user_token",
          action: "create",
          format: "json"
        )
      end
    end
  end

  describe "Pages" do
    describe "Home" do
      it "should route to pages#home" do
        expect(get: "/").to route_to(
          controller: "pages",
          action: "home"
        )
      end
    end
  end
end