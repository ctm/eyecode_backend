class AddUserTwidToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :user_twid, :integer, :null => false, :limit => 8
    rename_column :themes, :msg_id, :msg_twid
    add_index :users, :user_twid, :unique => true
  end

  def self.down
    rename_column :themes, :msg_twid, :msg_id
    remove_column :users, :user_twid
  end
end
