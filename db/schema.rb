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

ActiveRecord::Schema.define(version: 20170712190806) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "metadata"
    t.string "workflow_id", null: false
    t.string "subject_set_id", null: false
    t.integer "classroom_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "classrooms", id: :serial, force: :cascade do |t|
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
    t.bigint "projects_id"
    t.index ["projects_id"], name: "index_classrooms_on_projects_id"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "zooniverse_group_id"
    t.integer "classroom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "slug", null: false
    t.boolean "clone_workflow", default: false
    t.boolean "create_subject_set", default: false
    t.index ["slug"], name: "index_projects_on_slug", unique: true
  end

  create_table "student_assignments", id: :serial, force: :cascade do |t|
    t.integer "assignment_id"
    t.integer "student_user_id"
    t.integer "classifications_count", default: 0
  end

  create_table "student_users", id: :serial, force: :cascade do |t|
    t.integer "classroom_id"
    t.integer "user_id"
    t.integer "classifications_count", default: 0
    t.index ["classroom_id", "user_id"], name: "index_student_users_on_classroom_id_and_user_id", unique: true
  end

  create_table "teacher_users", id: :serial, force: :cascade do |t|
    t.integer "classroom_id"
    t.integer "user_id"
    t.index ["classroom_id", "user_id"], name: "index_teacher_users_on_classroom_id_and_user_id", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
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
  add_foreign_key "classrooms", "projects", column: "projects_id"
  add_foreign_key "student_assignments", "assignments", on_update: :cascade, on_delete: :cascade
  add_foreign_key "student_assignments", "student_users", on_update: :cascade, on_delete: :cascade
end
