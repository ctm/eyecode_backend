require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/user_sessions/new" do
  before(:each) do
    assign(:user_session, stub_model(User,
      :login => "value for login",
      :remember_me => true
    ).as_new_record)
  end

  it "renders the login form" do
    render :template => 'user_sessions/new', :layout => 'layouts/application'

    rendered.should have_selector('form', :action => user_session_path, :method => 'post') do |form|
      form.should have_selector('input#user_login', :name => 'user[login]')
      form.should have_selector('input#user_password', :name => 'user[password]')
      form.should have_selector('input#user_remember_me', :name => 'user[remember_me]')
    end

    rendered.should be_valid_xhtml
  end
end
