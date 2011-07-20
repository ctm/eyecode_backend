class RemoveNullConstraintFromPollsMaxId < ActiveRecord::Migration
  def up
    change_column :polls, :max_id, :integer, :limit => 8, :null => true
  end

  def down
    change_column :polls, :max_id, :integer, :limit => 8, :null => false
  end
end
