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

ActiveRecord::Schema.define(version: 20191030111334) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "change_stats", force: :cascade do |t|
    t.bigint "habitat_id"
    t.bigint "country_id"
    t.decimal "total_value_2007", default: "0.0", null: false
    t.decimal "total_value_2008", default: "0.0", null: false
    t.decimal "total_value_2009", default: "0.0", null: false
    t.decimal "total_value_2010", default: "0.0", null: false
    t.decimal "total_value_2015", default: "0.0", null: false
    t.integer "baseline_year", default: 2010, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_value_1996", default: "0.0", null: false
    t.decimal "total_value_2016", default: "0.0", null: false
    t.index ["country_id"], name: "index_change_stats_on_country_id"
    t.index ["habitat_id"], name: "index_change_stats_on_habitat_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "iso2", null: false
    t.string "iso3", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "country_stats", force: :cascade do |t|
    t.bigint "habitat_id"
    t.bigint "country_id"
    t.decimal "protected_value", default: "0.0", null: false
    t.decimal "total_value", default: "0.0", null: false
    t.decimal "protected_percentage", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_country_stats_on_country_id"
    t.index ["habitat_id"], name: "index_country_stats_on_habitat_id"
  end

  create_table "habitats", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "title", default: "", null: false
    t.string "theme", default: "", null: false
    t.string "poly_table"
    t.string "point_table"
    t.integer "global_coverage", default: 0, null: false
    t.integer "protected_percentage", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "wms_url"
  end

  create_table "regional_stats", force: :cascade do |t|
    t.bigint "habitat_id"
    t.bigint "country_id"
    t.decimal "total_area", default: "0.0", null: false
    t.decimal "total_points", default: "0.0", null: false
    t.decimal "total_protected", default: "0.0", null: false
    t.decimal "protected_percentage", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_regional_stats_on_country_id"
    t.index ["habitat_id"], name: "index_regional_stats_on_habitat_id"
  end

  add_foreign_key "change_stats", "countries"
  add_foreign_key "change_stats", "habitats"
  add_foreign_key "country_stats", "countries"
  add_foreign_key "country_stats", "habitats"
  add_foreign_key "regional_stats", "countries"
  add_foreign_key "regional_stats", "habitats"
end
