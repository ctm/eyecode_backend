class AddTweetedAtToThemes < ActiveRecord::Migration
  def self.up
    add_column :themes, :tweeted_at, :datetime, :null => false
    add_column :themes, :msg_id, :integer, :limit => 8, :null => false, :references => nil

    add_index :themes, :msg_id, :unique => true
  end

  def self.down
    remove_column :themes, :msg_id
    remove_column :themes, :tweeted_at
  end
end
