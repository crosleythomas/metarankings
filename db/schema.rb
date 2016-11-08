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

ActiveRecord::Schema.define(version: 20150507173456) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "images", force: true do |t|
    t.string   "team_name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keyvals", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publish_checkers", force: true do |t|
    t.string   "website"
    t.string   "publish_tok"
    t.integer  "week"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ranks", force: true do |t|
    t.string   "website"
    t.string   "team"
    t.integer  "rank"
    t.integer  "week"
    t.integer  "year"
    t.text     "description"
    t.string   "article_link"
    t.datetime "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scrape_configs", force: true do |t|
    t.string   "website"
    t.string   "url"
    t.string   "rank_xpath"
    t.string   "rank_regex"
    t.string   "team_xpath"
    t.string   "team_regex"
    t.string   "description_xpath"
    t.string   "description_regex"
    t.string   "update_checker_xpath"
    t.string   "update_checker_regex"
    t.integer  "week"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "standings", force: true do |t|
    t.string   "team"
    t.integer  "week"
    t.integer  "year"
    t.integer  "wins"
    t.integer  "losses"
    t.float    "percentage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "widgets", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "stock"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
