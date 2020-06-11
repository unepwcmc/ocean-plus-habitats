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

ActiveRecord::Schema.define(version: 20200611155949) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "change_stats", force: :cascade do |t|
    t.bigint "habitat_id"
    t.bigint "geo_entity_id"
    t.decimal "total_value_1996", default: "0.0", null: false
    t.decimal "total_value_2007", default: "0.0", null: false
    t.decimal "total_value_2008", default: "0.0", null: false
    t.decimal "total_value_2009", default: "0.0", null: false
    t.decimal "total_value_2010", default: "0.0", null: false
    t.decimal "total_value_2015", default: "0.0", null: false
    t.decimal "total_value_2016", default: "0.0", null: false
    t.integer "baseline_year", default: 2010, null: false
    t.decimal "protected_value", default: "0.0", null: false
    t.decimal "protected_percentage", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["geo_entity_id"], name: "index_change_stats_on_geo_entity_id"
    t.index ["habitat_id"], name: "index_change_stats_on_habitat_id"
  end

  create_table "coastal_stats", force: :cascade do |t|
    t.bigint "geo_entity_id"
    t.decimal "total_coast_length", default: "0.0"
    t.decimal "multiple_habitat_length", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["geo_entity_id"], name: "index_coastal_stats_on_geo_entity_id"
  end

  create_table "country_citations", force: :cascade do |t|
    t.text "citation", null: false
    t.integer "country_id", null: false
  end

  create_table "geo_entities", force: :cascade do |t|
    t.string "name", null: false
    t.string "iso3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "bounding_box", default: [], array: true
    t.index ["bounding_box"], name: "index_geo_entities_on_bounding_box", using: :gin
  end

  create_table "geo_entities_species", force: :cascade do |t|
    t.integer "geo_entity_id"
    t.integer "species_id"
    t.index ["geo_entity_id", "species_id"], name: "index_geo_entities_species_on_geo_entity_id_and_species_id", unique: true
    t.index ["geo_entity_id"], name: "index_geo_entities_species_on_geo_entity_id"
    t.index ["species_id"], name: "index_geo_entities_species_on_species_id"
  end

  create_table "geo_entity_stats", force: :cascade do |t|
    t.bigint "habitat_id"
    t.bigint "geo_entity_id"
    t.decimal "protected_value", default: "0.0", null: false
    t.decimal "total_value", default: "0.0", null: false
    t.decimal "protected_percentage", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "occurrence", limit: 2, default: 1
    t.decimal "coastal_coverage"
    t.index ["geo_entity_id"], name: "index_geo_entity_stats_on_geo_entity_id"
    t.index ["habitat_id"], name: "index_geo_entity_stats_on_habitat_id"
  end

  create_table "geo_entity_stats_sources", force: :cascade do |t|
    t.integer "geo_entity_stat_id"
    t.integer "citation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["geo_entity_stat_id", "citation_id"], name: "index_geo_entity_stat_source", unique: true
  end

  create_table "geo_relationships", force: :cascade do |t|
    t.bigint "country_id"
    t.bigint "region_id"
    t.index ["country_id"], name: "index_geo_relationships_on_country_id"
    t.index ["region_id"], name: "index_geo_relationships_on_region_id"
  end

  create_table "global_change_citations", force: :cascade do |t|
    t.text "citation", null: false
    t.text "citation_url", null: false
    t.bigint "global_change_stat_id"
    t.index ["global_change_stat_id"], name: "index_global_change_citations_on_global_change_stat_id"
  end

  create_table "global_change_stats", force: :cascade do |t|
    t.bigint "habitat_id"
    t.decimal "percentage_lost", default: "0.0"
    t.decimal "lower_bound_percentage", default: "0.0"
    t.decimal "upper_bound_percentage", default: "0.0"
    t.integer "baseline_year", null: false
    t.integer "recent_year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["habitat_id"], name: "index_global_change_stats_on_habitat_id"
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

  create_table "sources", force: :cascade do |t|
    t.integer "citation_id", null: false
    t.text "citation", null: false
    t.text "source_url"
  end

  create_table "species", force: :cascade do |t|
    t.string "scientific_name", null: false
    t.string "common_name"
    t.string "redlist_status", null: false
    t.bigint "habitat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["habitat_id"], name: "index_species_on_habitat_id"
  end

  add_foreign_key "change_stats", "geo_entities"
  add_foreign_key "change_stats", "habitats"
  add_foreign_key "geo_entity_stats", "geo_entities"
  add_foreign_key "geo_entity_stats", "habitats"
  add_foreign_key "geo_relationships", "geo_entities", column: "country_id"
  add_foreign_key "geo_relationships", "geo_entities", column: "region_id"
  add_foreign_key "global_change_stats", "habitats"
end
