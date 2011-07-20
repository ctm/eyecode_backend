require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/users/index.html.erb" do
  include Admin::UsersHelper

  before(:each) do
    users = assign(:users, [
      stub_model(User,
        :login => "value for login",
        :email => "value for email",
        :login_count => 1,
        :failed_login_count => 2,
        :current_login_ip => "value for current_login_ip",
        :last_login_ip => "value for last_login_ip",
        :active => false
      ),
      stub_model(User,
        :login => "value for login",
        :email => "value for email",
        :login_count => 3,
        :failed_login_count => 4,
        :current_login_ip => "value for current_login_ip",
        :last_login_ip => "value for last_login_ip",
        :active => false
      )
    ])
    users.should_receive(:total_pages).and_return(1)
  end

  it "renders a list of users" do
    render :template => 'admin/users/index', :layout => 'layouts/application'

    rendered.should have_selector("tr>td", :content => "value for login".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "value for email".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 1)
    rendered.should have_selector("tr>td", :content => 2.to_s, :count => 1)
    rendered.should have_selector("tr>td", :content => 3.to_s, :count => 1)
    rendered.should have_selector("tr>td", :content => 4.to_s, :count => 1)
    rendered.should have_selector("tr>td", :content => "value for current_login_ip".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "value for last_login_ip".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => false.to_s, :count => 2)
    rendered.should be_valid_xhtml
  end
end
