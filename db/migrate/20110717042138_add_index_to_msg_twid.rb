class AddIndexToMsgTwid < ActiveRecord::Migration
  def change
    add_index :tweets, :msg_twid, :unique => true
  end
end
