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

ActiveRecord::Schema.define(version: 20180218043425) do

  create_table "includes", force: :cascade do |t|
    t.integer "playlist_id"
    t.integer "track_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "playlists", force: :cascade do |t|
    t.string "name"
    t.boolean "collaborative"
    t.datetime "modified_at"
    t.integer "num_tracks"
    t.integer "num_albums"
    t.integer "num_followers"
    t.integer "num_edits"
    t.integer "duration_ms"
    t.integer "num_artists"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.string "track_name"
    t.string "artist_name"
    t.string "album_name"
    t.string "track_uri"
    t.string "artist_uri"
    t.string "album_uri"
    t.integer "duration_ms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["track_uri"], name: "index_tracks_on_track_uri", unique: true
  end

end
