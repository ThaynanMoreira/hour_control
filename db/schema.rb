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

ActiveRecord::Schema.define(:version => 20160107192950) do

  create_table "clients", :force => true do |t|
    t.string   "name",        :limit => 50, :null => false
    t.string   "description",               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "historics", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "work_date",  :null => false
    t.time     "enter_work", :null => false
    t.time     "exit_work",  :null => false
    t.text     "comment"
    t.float    "hours_used", :null => false
    t.integer  "task_id"
    t.integer  "type_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "name",        :limit => 50, :null => false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "client_id"
  end

  add_index "projects", ["user_id", "created_at"], :name => "index_projects_on_user_id_and_created_at"

  create_table "relations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relations", ["project_id"], :name => "index_relations_on_project_id"
  add_index "relations", ["user_id", "project_id"], :name => "index_relations_on_user_id_and_project_id", :unique => true
  add_index "relations", ["user_id"], :name => "index_relations_on_user_id"

  create_table "tasks", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "timetables", :force => true do |t|
    t.integer  "type_id"
    t.integer  "hours_amount",    :null => false
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "hours_completed", :null => false
    t.text     "observation"
    t.integer  "month"
    t.integer  "year"
  end

  add_index "timetables", ["project_id"], :name => "index_timetables_on_project_id"
  add_index "timetables", ["type_id"], :name => "index_timetables_on_type_id"

  create_table "types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "email",                             :null => false
    t.string   "password_salt"
    t.string   "password_hash"
    t.string   "image"
    t.integer  "type_id"
    t.string   "remember_token"
    t.boolean  "confirm",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["type_id"], :name => "index_users_on_type_id"

end
