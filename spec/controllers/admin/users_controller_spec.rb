require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::UsersController do

  before(:each) do
    controller.should_receive(:require_admin)
  end

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  describe "GET index" do
    it "assigns all users as @users" do
      User.stub!(:paginate).and_return([mock_user])
      get :index
      assigns[:users].should == [mock_user]
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      User.stub!(:find).with("37").and_return(mock_user)
      get :show, :id => "37"
      assigns[:user].should equal(mock_user)
    end
  end

  describe "GET new" do
    it "assigns a new user as @user" do
      User.stub!(:new).and_return(mock_user)
      get :new
      assigns[:user].should equal(mock_user)
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      User.stub!(:find).with("37").and_return(mock_user)
      get :edit, :id => "37"
      assigns[:user].should equal(mock_user)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created user as @user" do
        User.stub!(:new).with({'these' => 'params'}).and_return(mock_user(:save => true, :attributes= => {}))
        post :create, :user => {:these => 'params'}
        assigns[:user].should equal(mock_user)
      end

      it "redirects to the created user" do
        User.stub!(:new).and_return(mock_user(:save => true, :attributes= => {}))
        post :create, :user => {}
        response.should redirect_to(admin_user_url(mock_user))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        User.stub!(:new).with({'these' => 'params'}).and_return(mock_user(:attributes= => {}, :save => false))
        post :create, :user => {:these => 'params'}
        assigns[:user].should equal(mock_user)
      end

      it "re-renders the 'new' template" do
        User.stub!(:new).and_return(mock_user(:attributes= => {}, :save => false))
        post :create, :user => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested user" do
        User.should_receive(:find).with("37").and_return(mock_user(:save => true))
        mock_user.should_receive(:attributes=).with({'these' => 'params'})
        mock_user.should_receive(:attributes=).with({}, false)
        put :update, :id => "37", :user => {:these => 'params'}
      end

      it "assigns the requested user as @user" do
        User.stub!(:find).and_return(mock_user(:attributes= => {}, :save => true))
        put :update, :id => "1"
        assigns[:user].should equal(mock_user)
      end

      it "redirects to the user" do
        User.stub!(:find).and_return(mock_user(:attributes= => {}, :save => true))
        put :update, :id => "1"
        response.should redirect_to(admin_user_url(mock_user))
      end
    end

    describe "with invalid params" do
      it "updates the requested user" do
        User.should_receive(:find).with("37").and_return(mock_user(:save => false))
        mock_user.should_receive(:attributes=).with({'these' => 'params'})
        mock_user.should_receive(:attributes=).with({}, false)
        put :update, :id => "37", :user => {:these => 'params'}
      end

      it "assigns the user as @user" do
        User.stub!(:find).and_return(mock_user(:attributes= => {}, :save => false))
        put :update, :id => "1"
        assigns[:user].should equal(mock_user)
      end

      it "re-renders the 'edit' template" do
        User.stub!(:find).and_return(mock_user(:attributes= => {}, :save => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    describe "for non-admin destroy targets" do
      it "destroys the requested user" do
        User.should_receive(:find).with("37").and_return(mock_user)
        mock_user.should_receive(:admin?).and_return(false)
        mock_user.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the admin_users list" do
        User.stub!(:find).and_return(mock_user(:destroy => true))
        mock_user.should_receive(:admin?).and_return(false)
        delete :destroy, :id => "1"
        response.should redirect_to(admin_users_url)
      end
    end

    describe "for admin destroy targets" do
      describe "(HTML)" do
        it "doesn't destroy the requested user" do
          User.should_receive(:find).with("37").and_return(mock_user)
          mock_user.should_receive(:admin?).and_return(true)
          mock_user.should_not_receive(:destroy)
          delete :destroy, :id => "37"
          flash[:notice].should == 'An admin account may not be deleted.'
        end

        it "redirects to the admin_users list" do
          User.stub!(:find).and_return(mock_user(:destroy => true))
          mock_user.should_receive(:admin?).and_return(true)
          delete :destroy, :id => "1"
          response.should redirect_to(admin_users_url)
        end
      end

      describe "(XML)" do
        it "doesn't destroy the requested user" do
          User.should_receive(:find).with("37").and_return(mock_user)
          mock_user.should_receive(:admin?).and_return(true)
          mock_user.should_not_receive(:destroy)
          mock_user.errors.should_receive(:add_to_base).with('An admin account may not be deleted')
          delete :destroy, :id => "37", :format => 'xml'
        end

        it "returns an error" do
          User.should_receive(:find).with("37").and_return(mock_user)
          mock_user.should_receive(:admin?).and_return(true)
          mock_user.errors.should_receive(:add_to_base).with('An admin account may not be deleted')
          mock_user.errors.should_receive(:to_xml).and_return('xml formatted error')
          delete :destroy, :id => "37", :format => 'xml'
          response.body.should == 'xml formatted error'
        end

        it "returns the forbidden status" do
          User.should_receive(:find).with("37").and_return(mock_user)
          mock_user.should_receive(:admin?).and_return(true)
          mock_user.errors.should_receive(:add_to_base).with('An admin account may not be deleted')
          delete :destroy, :id => "37", :format => 'xml'
          response.code.should == '403'
        end
      end
    end
  end

end
