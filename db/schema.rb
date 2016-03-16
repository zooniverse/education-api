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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160309153138) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "classrooms", force: :cascade do |t|
    t.string   "name"
    t.integer  "zooniverse_group_id"
    t.string   "join_token"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "school"
    t.string   "subject"
    t.text     "description"
    t.integer  "classifications_count", default: 0
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "zooniverse_group_id"
    t.integer  "classroom_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "student_users", force: :cascade do |t|
    t.integer "classroom_id"
    t.integer "user_id"
    t.integer "classifications_count", default: 0
  end

  add_index "student_users", ["classroom_id", "user_id"], name: "index_student_users_on_classroom_id_and_user_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "zooniverse_id"
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "zooniverse_login"
    t.string   "zooniverse_display_name"
  end

end
