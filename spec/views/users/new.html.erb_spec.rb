require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/new.html.erb" do
  include UsersHelper

  before(:each) do
    assign(:user, stub_model(User,
      :login => "value for login",
      :email => "value for email"
    ).as_new_record)
  end

  it "renders new user form" do
    render :template => 'users/new', :layout => 'layouts/application'

    rendered.should have_selector('form', :action => user_path, :method => 'post') do |form|
      form.should have_selector('input#user_login', :name => 'user[login]')
      form.should have_selector('input#user_email', :name => 'user[email]')
      form.should have_selector('input#user_password', :name => 'user[password]')
      form.should have_selector('input#user_password_confirmation', :name => 'user[password_confirmation]')
    end
    rendered.should be_valid_xhtml
  end
end
