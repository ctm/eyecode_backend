require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  # should fail since there's no index
  describe "GET index" do
    it "raises a routing error" do
      lambda { get :index }.should raise_error(ActionController::RoutingError)
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      controller.should_receive(:current_user).at_least(:once).and_return(mock_user)
      get :show
      assigns[:user].should equal(mock_user)
    end
  end

  describe "GET new" do
    it "assigns a new user as @user" do
      controller.should_not_receive(:current_user)
      User.stub!(:new).and_return(mock_user)
      get :new
      assigns[:user].should equal(mock_user)
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      controller.should_receive(:current_user).at_least(:once).and_return(mock_user)
      get :edit
      assigns[:user].should equal(mock_user)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created active user as @user" do
        User.stub!(:new).with({'these' => 'params'}).and_return(mock_user(:attributes= => {}, :save => true))
        mock_user.should_receive(:active=).with(true)
        post :create, :user => {:these => 'params'}
        assigns[:user].should equal(mock_user)
      end

      it "redirects to the created user" do
        User.stub!(:new).and_return(mock_user(:attributes= => {}, :save => true, :active= => true))
        post :create, :user => {}
        response.should redirect_to(user_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        User.stub!(:new).with({'these' => 'params'}).and_return(mock_user(:attributes= => {}, :save => false, :active= => true))
        post :create, :user => {:these => 'params'}
        assigns[:user].should equal(mock_user)
      end

      it "re-renders the 'new' template" do
        User.stub!(:new).and_return(mock_user(:attributes= => {}, :save => false, :active= => true))
        post :create, :user => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested user" do
        controller.should_receive(:current_user).at_least(:once).and_return(mock_user)
        mock_user.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :user => {:these => 'params'}
      end

      it "assigns the requested user as @user" do
        controller.should_receive(:current_user).at_least(:once).and_return(mock_user(:update_attributes => true))
        put :update
        assigns[:user].should equal(mock_user)
      end

      it "redirects to the user" do
        controller.should_receive(:current_user).at_least(:once).and_return(mock_user(:update_attributes => true))
        put :update
        response.should redirect_to(user_url)
      end
    end

    describe "with invalid params" do
      it "updates the requested user" do
        controller.should_receive(:current_user).at_least(:once).and_return(mock_user)
        mock_user.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :user => {:these => 'params'}
      end

      it "assigns the user as @user" do
        controller.should_receive(:current_user).at_least(:once).and_return(mock_user(:update_attributes => false))
        put :update
        assigns[:user].should equal(mock_user)
      end

      it "re-renders the 'edit' template" do
        controller.should_receive(:current_user).at_least(:once).and_return(mock_user(:update_attributes => false))
        put :update
        response.should render_template('edit')
      end
    end

  end

  # should fail since there's no destroy
  describe "DELETE destroy" do
    it "raises a routing error" do
      lambda { delete :destroy, :id => "37" }.should raise_error(ActionController::RoutingError)
    end
  end

end
