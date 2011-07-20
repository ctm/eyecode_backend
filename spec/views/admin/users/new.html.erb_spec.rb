require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/users/new.html.erb" do
  include Admin::UsersHelper

  before(:each) do
    assign(:user, stub_model(User,
      :login => "value for login",
      :email => "value for email",
      :password => "value for password",
      :password_confirmation => "value for password",
      :active => false
    ).as_new_record)
  end

  it "renders new user form" do
    render :template => 'admin/users/new', :layout => 'layouts/application'

    rendered.should have_selector('form', :action => admin_users_path, :method => 'post') do |form|
      form.should have_selector('input#user_login', :name => 'user[login]')
      form.should have_selector('input#user_email', :name => 'user[email]')
      form.should have_selector('input#user_password', :name => 'user[password]')
      form.should have_selector('input#user_password_confirmation', :name => 'user[password_confirmation]')
      form.should have_selector('input#user_active', :name => 'user[active]')
    end

    rendered.should be_valid_xhtml
  end
end
