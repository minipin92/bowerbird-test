# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_03_01_132533) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "image_tags", force: :cascade do |t|
    t.bigint "image_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "probability"
    t.index ["image_id"], name: "index_image_tags_on_image_id"
    t.index ["tag_id"], name: "index_image_tags_on_tag_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "name"
    t.string "file"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "size"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_images_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "image_tags", "images"
  add_foreign_key "image_tags", "tags"
  add_foreign_key "images", "users"
  add_foreign_key "tags", "users"

  create_view "tag_views", sql_definition: <<-SQL
      SELECT tags.id,
      tags.name,
      tags.created_at,
      tags.updated_at,
      tags.user_id,
      COALESCE(image_tags_count.count, (0)::bigint) AS total_images_count
     FROM (tags
       LEFT JOIN ( SELECT image_tags.tag_id,
              count(*) AS count
             FROM image_tags
            GROUP BY image_tags.tag_id) image_tags_count ON ((tags.id = image_tags_count.tag_id)));
  SQL
end
