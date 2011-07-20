require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/show.html.erb" do
  include UsersHelper
  before(:each) do
    Time.zone = 'UTC'
    assign(:user, @user = stub_model(User,
      :login => "value for login",
      :email => "value for email",
      :login_count => 1,
      :failed_login_count => 2,
      :last_request_at => DateTime.parse('20090826140158'),
      :current_login_at => DateTime.parse('20090826140157'),
      :last_login_at => DateTime.parse('20090825140156'),
      :current_login_ip => "value for current_login_ip",
      :last_login_ip => "value for last_login_ip"
    ))
  end

  it "renders attributes in <p>" do
    render :template => 'users/show', :layout => 'layouts/application'

    rendered.should contain(/value\ for\ login/)
    rendered.should contain(/value\ for\ email/)
    rendered.should contain(/1/)
    rendered.should contain(/2/)
    rendered.should contain(/14:01:58/)
    rendered.should contain(/14:01:57/)
    rendered.should contain(/14:01:56/)
    rendered.should contain(/value\ for\ current_login_ip/)
    rendered.should contain(/value\ for\ last_login_ip/)
    rendered.should be_valid_xhtml
  end
end
