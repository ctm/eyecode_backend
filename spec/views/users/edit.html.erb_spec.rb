require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/edit.html.erb" do
  include UsersHelper

  before(:each) do
    assign(:user, @user = stub_model(User,
      :login => "value for login",
      :email => "value for email"
    ))
  end

  it "renders the edit user form" do
    render :template => 'users/edit', :layout => 'layouts/application'

    rendered.should have_selector('form', :action => user_path, :method => 'post') do |form|
      form.should have_selector('input#user_email', :name => 'user[email]')
      form.should have_selector('input#user_password', :name => 'user[password]')
      form.should have_selector('input#user_password_confirmation', :name => 'user[password_confirmation]')
    end
    rendered.should be_valid_xhtml
  end
end
