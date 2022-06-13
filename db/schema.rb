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

ActiveRecord::Schema[7.0].define(version: 2022_06_12_122936) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", id: :serial, force: :cascade do |t|
    t.string "name", null: false, comment: "author's name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_authors_on_name"
  end

  create_table "ratings", id: :serial, force: :cascade do |t|
    t.integer "recipe_id", null: false, comment: "recipe.id"
    t.integer "author_id", null: false, comment: "author.id"
    t.integer "rate", null: false, comment: "author's rating against recipe"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_ratings_on_author_id"
    t.index ["rate"], name: "index_ratings_on_rate"
    t.index ["recipe_id", "author_id"], name: "index_ratings_on_recipe_id_and_author_id", unique: true
    t.index ["recipe_id"], name: "index_ratings_on_recipe_id"
  end

  create_table "recipes", id: :serial, force: :cascade do |t|
    t.string "title", null: false, comment: "recipe's title"
    t.integer "author_id", null: false, comment: "author.id"
    t.string "description", default: "", comment: "recipe's description"
    t.jsonb "ingredient", null: false, comment: "ingredient json"
    t.string "process", default: "", comment: "recipe's process"
    t.datetime "deleted_at", comment: "deleted at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_recipes_on_author_id"
    t.index ["deleted_at"], name: "index_recipes_on_deleted_at"
  end

  add_foreign_key "ratings", "authors"
  add_foreign_key "ratings", "recipes"
  add_foreign_key "recipes", "authors"
end
