require "spec_helper"

describe TweetsController do
  describe "routing" do

    it "routes to #index" do
      get("/tweets").should route_to("tweets#index")
    end

    it "routes to #show" do
      get("/tweets/1").should route_to("tweets#show", :id => "1")
    end

  end
end
