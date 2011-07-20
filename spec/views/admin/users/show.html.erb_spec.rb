require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/users/show.html.erb" do
  include Admin::UsersHelper
  before(:each) do
    assign(:user, @user = stub_model(User,
      :login => "value for login",
      :email => "value for email",
      :login_count => 1,
      :failed_login_count => 1,
      :current_login_ip => "value for current_login_ip",
      :last_login_ip => "value for last_login_ip",
      :active => false
    ))
  end

  it "renders attributes in <p>" do
    render :template => 'admin/users/show', :layout => 'layouts/application'

    rendered.should contain(/value\ for\ login/)
    rendered.should contain(/value\ for\ email/)
    rendered.should contain(/1/)
    rendered.should contain(/1/)
    rendered.should contain(/value\ for\ current_login_ip/)
    rendered.should contain(/value\ for\ last_login_ip/)
    rendered.should contain(/false/)

    rendered.should be_valid_xhtml
  end
end
