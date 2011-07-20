require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  describe 'routing' do
    it "routes to #new" do
      get("/user/new").should route_to('users#new')
    end

    it "routes to #show" do
      get("/user").should route_to('users#show')
    end

    it "routes to #edit" do
      get("/user/edit").should route_to('users#edit')
    end

    it "routes to #create" do
      post('/user').should route_to('users#create')
    end

    it "routes to #update" do
      put('/user').should route_to('users#update')
    end
  end
end
