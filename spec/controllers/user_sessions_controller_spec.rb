require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionsController do

  #Delete these examples and add some real ones
  it "should use UserSessionsController" do
    controller.should be_an_instance_of(UserSessionsController)
  end


  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    describe 'with valid parameters' do
      it 'should successfully log in' do
        controller.should_receive(:current_user).and_return(nil)
        UserSession.should_receive(:new).and_return(mock(UserSession, :save => true))
        controller.should_receive(:root_url).and_return('/')
        get 'create'
        flash[:notice].should == 'Login successful.'
        response.should redirect_to('/')
      end
    end

    describe 'with invalid parameters' do
      it 'should fail and re-render new' do
        get 'create'
        flash[:notice].should_not ~ /success/i
        response.should render_template(:new)
      end
    end
  end

  describe "GET 'destroy'" do
    it "should redirect to root_url" do
      controller.should_receive(:current_user).and_return(mock_model(User))
      controller.should_receive(:current_user_session).and_return(mock(UserSession, :destroy => nil))
      controller.should_receive(:root_url).and_return('/')
      get 'destroy'
      response.should redirect_to('/')
    end
  end
end
