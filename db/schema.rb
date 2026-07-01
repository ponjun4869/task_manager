ActiveRecord::Schema[7.1].define(version: 2026_07_01_100131) do
 
  enable_extension "plpgsql"

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "status"
    t.integer "priority"
    t.date "deadline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
