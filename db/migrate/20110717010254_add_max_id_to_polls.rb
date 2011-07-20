class AddMaxIdToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :max_id, :integer, :limit => 8, :null => false
    rename_column :polls, :hash, :tag
  end
end
