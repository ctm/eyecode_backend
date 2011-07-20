class RemoveTableIntValues < ActiveRecord::Migration
  # This is a one-way migration.  We won't be going back from eyedropr to
  # tp_themes.  So there.
  def up
    drop_table :int_values
    drop_table :rates
    drop_table :themes

    create_table :polls do |t|
      t.string :hash, :null => false
      t.timestamps
    end
  end

  def down
    # One way migration.
  end
end
