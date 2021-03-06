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

ActiveRecord::Schema.define(version: 20170528094638) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cron_jobs", force: :cascade do |t|
    t.string "name", null: false
    t.string "schedule"
    t.string "command"
    t.datetime "next_run_at"
    t.boolean "enabled", default: true
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_cron_jobs_on_created_at"
    t.index ["enabled"], name: "index_cron_jobs_on_enabled"
    t.index ["name"], name: "index_cron_jobs_on_name", unique: true
    t.index ["next_run_at"], name: "index_cron_jobs_on_next_run_at"
    t.index ["updated_at"], name: "index_cron_jobs_on_updated_at"
  end

  create_table "feed_articles", force: :cascade do |t|
    t.bigint "feed_id", null: false
    t.string "guid", null: false
    t.datetime "published_at", null: false
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_feed_articles_on_created_at"
    t.index ["feed_id", "guid"], name: "index_feed_articles_on_feed_id_and_guid", unique: true
    t.index ["feed_id"], name: "index_feed_articles_on_feed_id"
    t.index ["published_at"], name: "index_feed_articles_on_published_at"
    t.index ["updated_at"], name: "index_feed_articles_on_updated_at"
  end

  create_table "feed_bots", force: :cascade do |t|
    t.bigint "feed_id"
    t.string "username", null: false
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_feed_bots_on_created_at"
    t.index ["data"], name: "index_feed_bots_on_data", using: :gin
    t.index ["feed_id"], name: "index_feed_bots_on_feed_id"
    t.index ["updated_at"], name: "index_feed_bots_on_updated_at"
    t.index ["username"], name: "index_feed_bots_on_username", unique: true
  end

  create_table "feeds", force: :cascade do |t|
    t.bigint "user_id"
    t.string "slug", null: false
    t.string "url", null: false
    t.string "avatar"
    t.boolean "verified", default: false
    t.datetime "last_crawled_at"
    t.datetime "will_crawled_at"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_posted_at"
    t.boolean "private", default: false
    t.index ["created_at"], name: "index_feeds_on_created_at"
    t.index ["data"], name: "index_feeds_on_data", using: :gin
    t.index ["last_crawled_at"], name: "index_feeds_on_last_crawled_at"
    t.index ["last_posted_at"], name: "index_feeds_on_last_posted_at"
    t.index ["private"], name: "index_feeds_on_private"
    t.index ["slug"], name: "index_feeds_on_slug", unique: true
    t.index ["updated_at"], name: "index_feeds_on_updated_at"
    t.index ["url"], name: "index_feeds_on_url", unique: true
    t.index ["user_id"], name: "index_feeds_on_user_id"
    t.index ["verified"], name: "index_feeds_on_verified"
    t.index ["will_crawled_at"], name: "index_feeds_on_will_crawled_at"
  end

  create_table "identities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_identities_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "mastodon_clients", force: :cascade do |t|
    t.string "domain", null: false
    t.string "client_id", null: false
    t.string "client_secret", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_mastodon_clients_on_created_at"
    t.index ["domain"], name: "index_mastodon_clients_on_domain", unique: true
    t.index ["updated_at"], name: "index_mastodon_clients_on_updated_at"
  end

  create_table "que_jobs", primary_key: ["queue", "priority", "run_at", "job_id"], force: :cascade, comment: "3" do |t|
    t.integer "priority", limit: 2, default: 100, null: false
    t.datetime "run_at", default: -> { "now()" }, null: false
    t.bigserial "job_id", null: false
    t.text "job_class", null: false
    t.json "args", default: [], null: false
    t.integer "error_count", default: 0, null: false
    t.text "last_error"
    t.text "queue", default: "", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "feed_id"
    t.string "secret"
    t.string "hub"
    t.boolean "subscribed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_subscriptions_on_created_at"
    t.index ["feed_id"], name: "index_subscriptions_on_feed_id"
    t.index ["subscribed"], name: "index_subscriptions_on_subscribed"
    t.index ["updated_at"], name: "index_subscriptions_on_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "feed_articles", "feeds"
  add_foreign_key "feed_bots", "feeds"
  add_foreign_key "feeds", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "subscriptions", "feeds"
end
