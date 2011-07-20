class AllowMsgTwidToBeNull < ActiveRecord::Migration
  def self.up
    change_column :themes, :msg_twid, :integer, :limit => 8, :null => true
    change_column :themes, :tweeted_at, :datetime, :null => true
  end

  def self.down
    change_column :themes, :msg_twid, :integer, :limit => 8, :null => false
    change_column :themes, :tweeted_at, :datetime, :null => false
  end
end
