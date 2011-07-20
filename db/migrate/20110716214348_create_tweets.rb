class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :user, :null => false
      t.datetime :tweeted_at, :null => false
      t.integer :msg_twid, :limit => 8, :null => false
      t.string :raw_text, :null => false
      t.string :text
      t.string :image_url

      t.timestamps
    end
  end
end
