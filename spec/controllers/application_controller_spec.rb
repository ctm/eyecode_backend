require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do
  describe 'update_protected_attrs_from_params' do
    before(:each) do
      # Freeze the params so that we get an error if anything tries to
      # alter them.
      @some_params = { :user => { :login => 'ctm', :password => 'foo' } }.freeze
      controller.should_receive(:params).and_return(@some_params)
    end

    it 'works even if params[key] is nil' do
      user = mock_model(User, :attributes= => {})
      lambda {
        controller.instance_eval do
          update_protected_attrs_from_params(:bad_key, :login) do |p|
            user
          end
        end
      }.should_not raise_error
    end

    it 'yields using a copy of params lacking the protected ones' do
      saved_params = @some_params.dup
      user = mock_model(User, :attributes= => {})
      controller.instance_eval do
        update_protected_attrs_from_params(:user, :login) do |p|
          p.should == { :password => 'foo' }
          user
        end
      end
      @some_params.should == saved_params
    end

    it 'manually assigns the protected attrs' do
      user = mock_model(User)
      user.should_receive(:attributes=).with({:login => 'ctm'}, false)
      controller.instance_eval do
        update_protected_attrs_from_params(:user, :login) do |p|
          user
        end
      end
    end

    it "doesn't update an attribute that doesn't appear in params" do
      user = mock_model(User)
      user.should_receive(:attributes=).with({}, false)
      controller.instance_eval do
        update_protected_attrs_from_params(:user) do |p|
          user
        end
      end
    end

    it 'returns the model that yield returned' do
      user = mock_model(User)
      user.should_receive(:attributes=).with({:login => 'ctm'}, false)
      controller.instance_eval do
        update_protected_attrs_from_params(:user, :login) do |p|
          user
        end.should == user
      end
    end
  end

  describe 'current_user_session' do
    describe 'when cached' do
      # Test for nil specifically, just to verify that we don't have an "||"
      # error that doesn't return nil when it should.
      # e.g.,
      #   @ivar || (@ivar = setter)
      # will not return nil if @ivar is nil

      it 'if nil, it returns nil' do
        controller.instance_eval { @current_user_session = nil
                               defined?(@current_user_session) }.should be_true
        controller.instance_eval { current_user_session }.should be_nil
      end

      it 'if non-nil, it returns that value' do
        expected_session = mock(UserSession)
        controller.instance_eval { @current_user_session = expected_session
                               defined?(@current_user_session) }.should be_true
        controller.instance_eval { current_user_session }.should == expected_session
      end
    end

    describe 'when not cached' do
      it 'returns the result of UserSession.find' do
        expected_session = mock(UserSession, :user => mock_model(User, :time_zone => nil))
        controller.instance_eval { defined?(@current_user_session) }.should be_nil
        UserSession.should_receive(:find).and_return(expected_session)
        controller.instance_eval { current_user_session }.should == expected_session
      end

      it 'caches the result of UserSession.find' do
        expected_session = mock(UserSession, :user => mock_model(User, :time_zone => nil))
        controller.instance_eval { defined?(@current_user_session) }.should be_nil
        UserSession.should_receive(:find).and_return(expected_session)
        controller.instance_eval { current_user_session }.should == expected_session
        controller.instance_eval { @current_user_session }.should == expected_session
      end
    end

    it "sets the time zone" do
      expected_session = mock(UserSession, :user => mock_model(User, :time_zone => 'Eastern Time (US & Canada)'))
      Time.zone.to_s.should ~ /Mountain Time/
      UserSession.should_receive(:find).and_return(expected_session)
      controller.instance_eval { current_user_session }
      Time.zone.to_s.should ~ /Eastern Time/
    end
  end

  describe 'current_user' do
    describe 'when cached' do
      it 'if nil, it returns nil' do
        controller.instance_eval { @current_user = nil
                               defined?(@current_user) }.should be_true
        controller.instance_eval { current_user }.should be_nil
      end

      it 'if non-nil, it returns that value' do
        expected_session = mock(UserSession)
        controller.instance_eval { @current_user = expected_session
                               defined?(@current_user) }.should be_true
        controller.instance_eval { current_user }.should == expected_session
      end
    end

    describe 'when not cached' do
      it 'returns nil if current_user_session is nil' do
        controller.should_receive(:current_user_session).and_return(nil)
        controller.instance_eval { current_user }.should be_nil
      end

      it 'returns the user for current_user_session if current_user_session is non-nil' do
        expected_user = mock_model(User)
        expected_session = mock(UserSession, :user => expected_user)        
        controller.should_receive(:current_user_session).twice.and_return(expected_session)
        controller.instance_eval { current_user }.should == expected_user
      end

      it 'caches the returned value' do
        expected_user = mock_model(User)
        expected_session = mock(UserSession, :user => expected_user)        
        controller.should_receive(:current_user_session).twice.and_return(expected_session)
        controller.instance_eval { current_user }.should == expected_user
        controller.instance_eval { @current_user }.should == expected_user
      end
    end
  end

  describe 'admin?' do
    it "returns false if there's no current user" do
      controller.should_receive(:current_user).and_return nil
      controller.instance_eval { admin? }.should be_false
    end

    it "returns the models admin? value if there's a user" do
      controller.should_receive(:current_user).twice.and_return(mock_model(User, :admin? => 'what we mocked'))
      controller.instance_eval { admin? }.should == 'what we mocked'
    end
  end
end

# To test our various filters we make a controller that inherits from
# ApplicationController and set up some filters and use get instead of
# instance_eval to have our test code executed.

class ApplicationControllerTestController < ApplicationController
  before_filter :require_user, :only => :require_user_test
  before_filter :require_no_user, :only => :require_no_user_test
  before_filter :require_admin, :only => :require_admin_test

  def require_user_test
    head :ok
  end

  def require_admin_test
    head :ok
  end

  def save_notify_and_redirect_test
    save_notify_and_redirect 'moving soon', '/montana'
  end

  def require_no_user_test
    head :ok
  end
end

describe ApplicationControllerTestController do
  describe 'require_user' do
    it "doesn't halt the filter chain if a user is logged in" do
      controller.should_receive(:current_user).and_return(mock_model(User))
      get :require_user_test
      response.should be_success
    end

    describe 'with no logged in user' do
      it 'saves the current uri' do
        get :require_user_test
        session[:return_to].should == '/require_user'
      end

      it 'sets up a flash notice' do
        get :require_user_test
        flash[:notice].should == 'You must be logged in to access this page.'
      end

      it 'redirects' do
        get :require_user_test
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe 'require_no_user' do
    it 'redirects if a user is logged in' do
      controller.should_receive(:current_user).and_return(mock_model(User))
      get :require_no_user_test
      response.should redirect_to(user_url)
    end

    it "doesn't halt the filter chain if no user is logged in" do
      controller.should_receive(:current_user).and_return(nil)
      get :require_no_user_test
      response.should be_success
    end
  end

  describe 'require_admin' do
    it 'does nothing if an admin is logged in' do
      controller.should_receive(:current_user).at_least(:once).and_return(mock_model(User, :admin? => true))
      get :require_admin_test
      response.should be_success
    end

    it 'requires logging in if not logged in' do
      get :require_admin_test
      flash[:notice].should == 'You must be logged in to access this page.'
      response.should redirect_to(new_user_session_url)
    end

    it 'requires an admin if logged in but not admin' do
      controller.should_receive(:current_user).at_least(:once).and_return(mock_model(User, :admin? => false))
      controller.should_receive(:root_url).and_return('/')
      get :require_admin_test
      flash[:notice].should == 'You must be an admin to access this page.'
      response.should redirect_to('/')
    end
  end

  describe 'save_notify_and_redirect' do
    it 'saves the current uri' do
      get :save_notify_and_redirect_test
      session[:return_to].should == '/save_notify_and_redirect'
    end

    it 'sets the flash notice' do
      get :save_notify_and_redirect_test
      flash[:notice].should == 'moving soon'
    end

    it 'redirects' do
      get :save_notify_and_redirect_test
      response.should redirect_to('/montana')
    end
  end
end

