class CreateIntValues < ActiveRecord::Migration
  def self.up
    create_table :int_values do |t|
      t.integer :value, :limit => 8

      t.timestamps
    end
  end

  def self.down
    drop_table :int_values
  end
end
