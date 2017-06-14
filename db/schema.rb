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

ActiveRecord::Schema.define(version: 20170427120805) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "metadata"
    t.string "workflow_id", null: false
    t.string "subject_set_id", null: false
    t.bigint "classroom_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["classroom_id"], name: "index_assignments_on_classroom_id"
  end

  create_table "classrooms", force: :cascade do |t|
    t.string "name"
    t.integer "zooniverse_group_id"
    t.string "join_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "school"
    t.string "subject"
    t.text "description"
    t.integer "classifications_count", default: 0
    t.datetime "deleted_at"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.integer "zooniverse_group_id"
    t.bigint "classroom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_groups_on_classroom_id"
  end

  create_table "student_assignments", force: :cascade do |t|
    t.bigint "assignment_id"
    t.bigint "student_user_id"
    t.integer "classifications_count", default: 0
    t.index ["assignment_id"], name: "index_student_assignments_on_assignment_id"
    t.index ["student_user_id"], name: "index_student_assignments_on_student_user_id"
  end

  create_table "student_users", force: :cascade do |t|
    t.bigint "classroom_id"
    t.bigint "user_id"
    t.integer "classifications_count", default: 0
    t.index ["classroom_id", "user_id"], name: "index_student_users_on_classroom_id_and_user_id", unique: true
    t.index ["classroom_id"], name: "index_student_users_on_classroom_id"
    t.index ["user_id"], name: "index_student_users_on_user_id"
  end

  create_table "teacher_users", force: :cascade do |t|
    t.bigint "classroom_id"
    t.bigint "user_id"
    t.index ["classroom_id", "user_id"], name: "index_teacher_users_on_classroom_id_and_user_id", unique: true
    t.index ["classroom_id"], name: "index_teacher_users_on_classroom_id"
    t.index ["user_id"], name: "index_teacher_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "zooniverse_id"
    t.string "access_token"
    t.string "refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "zooniverse_login"
    t.string "zooniverse_display_name"
    t.jsonb "metadata"
    t.index ["zooniverse_id"], name: "index_users_on_zooniverse_id", unique: true
  end

  add_foreign_key "assignments", "classrooms"
  add_foreign_key "student_assignments", "assignments", on_update: :cascade, on_delete: :cascade
  add_foreign_key "student_assignments", "student_users", on_update: :cascade, on_delete: :cascade
end
