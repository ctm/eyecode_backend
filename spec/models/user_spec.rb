require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @valid_attributes = {
      :login => "ctm",
      :password => "value for password",
      :password_confirmation => "value for password",
      :crypted_password => "value for password"
    }
  end

  it "creates a new instance given valid attributes" do
    u = User.new(@valid_attributes)
    u.login = @valid_attributes[:login]
    u.user_twid = 1
    u.save!
  end

  it "doesn't allow invalid time zones" do
    u = User.new(@valid_attributes)
    u.login = @valid_attributes[:login]
    u.user_twid = 1
    u.time_zone = 'Spring Time'
    u.save.should be_false
    u.errors[:time_zone].should == ['is not a valid time zone']
  end

  describe 'admin?' do
    it "is true if the record isn't new and login == 'admin'" do
      u = User.new(@valid_attributes)
      u.login = 'admin'
      u.user_twid = 1
      u.save!
      u.should be_admin
    end

    it "is false if the record is new" do
      u = User.new(@valid_attributes)
      u.login = 'admin'
      u.user_twid = 1
      u.should_not be_admin
    end
    
    it "is false if login != 'admin'" do
      u = User.new(@valid_attributes)
      u.login = 'root'
      u.user_twid = 1
      u.save!
      u.should_not be_admin
    end
  end
end
