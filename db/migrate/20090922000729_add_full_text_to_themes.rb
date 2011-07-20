require 'migration_helpers/populate_full_text'

class AddFullTextToThemes < ActiveRecord::Migration
  include MigrationHelpers::PopulateFullText

  def self.up
    add_column :themes, :full_text, :string
    populate_full_text
    change_column :themes, :full_text, :string, :null => false
  end

  def self.down
    remove_column :themes, :full_text
  end
end
