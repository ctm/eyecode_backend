class AddSearchResultToThemes < ActiveRecord::Migration
  def self.up
    add_column :themes, :search_result, :text
  end

  def self.down
    remove_column :themes, :search_result
  end
end
