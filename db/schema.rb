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

ActiveRecord::Schema.define(:version => 20120720005544) do

  create_table "assignments", :force => true do |t|
    t.integer  "deacon_id"
    t.integer  "client_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "exit_notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "clients", :force => true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.string   "gender"
    t.string   "ethnicity"
    t.string   "marital_status"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.string   "phone"
    t.boolean  "gov_assistance"
    t.boolean  "is_employed"
    t.boolean  "is_veteran"
    t.boolean  "active"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "deacons", :force => true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.string   "email"
    t.string   "password"
    t.string   "password_hash"
    t.string   "phone"
    t.string   "gender"
    t.string   "role"
    t.boolean  "active"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
