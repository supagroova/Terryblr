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

ActiveRecord::Schema.define(:version => 20110216181030) do

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "body",           :limit => 3000
    t.string   "slug"
    t.datetime "published_at"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likes_count",                    :default => 0
    t.integer  "comments_count",                 :default => 0
    t.integer  "votes_count",                    :default => 0
    t.integer  "parent_id"
    t.integer  "position",                       :default => 0
    t.integer  "post_id"
  end

  add_index "pages", ["comments_count"], :name => "index_pages_on_comments_count"
  add_index "pages", ["likes_count"], :name => "index_pages_on_likes_count"
  add_index "pages", ["parent_id"], :name => "index_pages_on_parent_id"
  add_index "pages", ["post_id"], :name => "index_pages_on_post_id"
  add_index "pages", ["slug"], :name => "index_pages_on_slug"
  add_index "pages", ["votes_count"], :name => "index_pages_on_votes_count"

  create_table "posts", :force => true do |t|
    t.string   "post_type"
    t.string   "title"
    t.string   "body",                  :limit => 3000
    t.string   "slug"
    t.datetime "published_at"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tumblr_id"
    t.integer  "likes_count",                           :default => 0
    t.integer  "comments_count",                        :default => 0
    t.integer  "votes_count",                           :default => 0
    t.integer  "twitter_id"
    t.integer  "facebook_id"
    t.string   "display_type"
    t.integer  "tw_delayed_job_id"
    t.integer  "fb_delayed_job_id"
    t.string   "social_msg",            :limit => 140
    t.integer  "linkable_id"
    t.string   "linkable_type"
    t.integer  "tumblr_delayed_job_id"
  end

  add_index "posts", ["comments_count"], :name => "index_posts_on_comments_count"
  add_index "posts", ["likes_count"], :name => "index_posts_on_likes_count"
  add_index "posts", ["linkable_id"], :name => "index_posts_on_linkable_id"
  add_index "posts", ["slug"], :name => "index_posts_on_slug"
  add_index "posts", ["tumblr_delayed_job_id"], :name => "index_posts_on_tumblr_delayed_job_id"
  add_index "posts", ["twitter_id"], :name => "index_posts_on_twitter_id"
  add_index "posts", ["votes_count"], :name => "index_posts_on_votes_count"

end
