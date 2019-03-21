require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  render_views
  
  describe "#home" do
    it "should render home template" do
      get :home
      expect(response).to render_template(:home)
    end
    
    it "should render status 200" do
      get :home
      expect(response).to have_http_status(:success)
    end
  end
end
