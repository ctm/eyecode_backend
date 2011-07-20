class AddInstallsToTheme < ActiveRecord::Migration
  def self.up
    add_column :themes, :installs, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :themes, :installs
  end
end

