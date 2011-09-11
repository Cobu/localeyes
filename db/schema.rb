# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20110813215827) do

  create_table "businesses", :force => true do |t|
    t.integer "user_id",                                                :null => false
    t.string  "name",                                                   :null => false
    t.integer "service_type",                                           :null => false
    t.string  "description"
    t.string  "time_zone",    :default => "Eastern Time (US & Canada)"
    t.string  "address",                                                :null => false
    t.string  "address2"
    t.string  "city",                                                   :null => false
    t.string  "state",                                                  :null => false
    t.string  "zip_code",                                               :null => false
    t.string  "phone",                                                  :null => false
    t.text    "hours"
    t.string  "url"
    t.binary  "image"
    t.float   "lat",                                                    :null => false
    t.float   "lng",                                                    :null => false
    t.boolean "active"
  end

  create_table "colleges", :force => true do |t|
    t.string "name",        :null => false
    t.string "address",     :null => false
    t.string "city",        :null => false
    t.string "state_short", :null => false
    t.string "zip_code",    :null => false
    t.float  "lat",         :null => false
    t.float  "lng",         :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "business_id",                :null => false
    t.integer  "event_type",  :default => 0
    t.string   "title",                      :null => false
    t.string   "description"
    t.text     "schedule"
    t.datetime "start_time",                 :null => false
    t.datetime "end_time",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string "type"
    t.string "email",           :null => false
    t.string "password_digest", :null => false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
  end

  create_table "zip_codes", :force => true do |t|
    t.string "city",                     :null => false
    t.string "state",                    :null => false
    t.string "state_short", :limit => 2, :null => false
    t.string "zip_code",                 :null => false
    t.float  "lat",                      :null => false
    t.float  "lng",                      :null => false
  end

  add_index "zip_codes", ["zip_code"], :name => "index_zip_codes_on_zip_code", :unique => true

end
