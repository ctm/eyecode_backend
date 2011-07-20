# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110717211718) do

  create_table "polls", :force => true do |t|
    t.string   "tag",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_id",     :limit => 8
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tweets", :force => true do |t|
    t.string   "user",                    :null => false
    t.datetime "tweeted_at",              :null => false
    t.integer  "msg_twid",   :limit => 8, :null => false
    t.string   "raw_text",                :null => false
    t.string   "text"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tweets", ["msg_twid"], :name => "index_tweets_on_msg_twid", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login",                                               :null => false
    t.string   "time_zone"
    t.string   "crypted_password",                                    :null => false
    t.string   "password_salt",                                       :null => false
    t.string   "persistence_token",                                   :null => false
    t.string   "single_access_token",                                 :null => false
    t.string   "perishable_token",                                    :null => false
    t.integer  "login_count",                      :default => 0,     :null => false
    t.integer  "failed_login_count",               :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "active",                           :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_twid",           :limit => 8,                    :null => false
  end

  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["user_twid"], :name => "index_users_on_user_twid", :unique => true

end
