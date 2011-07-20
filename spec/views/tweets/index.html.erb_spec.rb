require 'spec_helper'

describe "tweets/index.html.erb" do
  before(:each) do
    assign(:tweets, [
      stub_model(Tweet,
        :user => "User",
        :msg_twid => 1,
        :raw_text => "Raw Text",
        :text => "Text",
        :image_url => "Image Url"
      ),
      stub_model(Tweet,
        :user => "User",
        :msg_twid => 1,
        :raw_text => "Raw Text",
        :text => "Text",
        :image_url => "Image Url"
      )
    ])
  end

  it "renders a list of tweets" do
    render :template => 'tweets/index', :layout => 'layouts/application'
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "User".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Text".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Image Url".to_s, :count => 2

    rendered.should be_valid_xhtml
  end
end
