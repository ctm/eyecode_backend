class AddRatingToTheme < ActiveRecord::Migration
  def self.up
    add_column :themes, :rating, :float
  end

  def self.down
    remove_column :themes, :rating
  end
end
