require "spec_helper"

describe FeedsController do
  describe "routing" do

    it "routes to #index" do
      get("/feeds").should route_to("feeds#index")
    end

    it "routes to #new" do
      get("/feeds/new").should route_to("feeds#new")
    end

    it "routes to #show" do
      get("/feeds/1").should route_to("feeds#show", :id => "1")
    end

    it "routes to #edit" do
      get("/feeds/1/edit").should route_to("feeds#edit", :id => "1")
    end

    it "routes to #create" do
      post("/feeds").should route_to("feeds#create")
    end

    it "routes to #update" do
      put("/feeds/1").should route_to("feeds#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/feeds/1").should route_to("feeds#destroy", :id => "1")
    end

  end
end
