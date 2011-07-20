class DisallowNullSearchResult < ActiveRecord::Migration
  def self.up
    change_column :themes, :search_result, :text, :null => false
  end

  def self.down
    change_column :themes, :search_result, :text, :null => true
  end
end
