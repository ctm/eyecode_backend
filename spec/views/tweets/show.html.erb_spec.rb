require 'spec_helper'

describe "tweets/show.html.erb" do
  before(:each) do
    @image_url = "http://instagr.am/p/Hz-Ma/"
    @tweet = assign(:tweet, stub_model(Tweet,
      :user => "User",
      :msg_twid => 1,
      :raw_text => "Raw Text",
      :text => "Text",
      :image_url => @image_url
    ))
  end

  it "renders attributes in <p>" do
    render :template => 'tweets/show', :layout => 'layouts/application'

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/User/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Raw Text/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Text/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(@image_url)

    rendered.should be_valid_xhtml
  end
end
