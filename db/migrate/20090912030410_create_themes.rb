class CreateThemes < ActiveRecord::Migration
  def self.up
    create_table :themes do |t|
      t.references :user, :null => false
      t.string :name
      t.string :font, :null => false
      t.string :size, :null => false
      t.string :text_color, :null => false
      t.string :background_color, :null => false

      t.timestamps
    end

    add_index :themes, [:user_id, :name], :unique => true, :case_sensitive => false
  end

  def self.down
    drop_table :themes
  end
end
