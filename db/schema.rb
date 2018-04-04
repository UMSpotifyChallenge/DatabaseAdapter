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

ActiveRecord::Schema.define(version: 20180404043211) do

  create_table "albums", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "uri"
    t.bigint "artist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_albums_on_artist_id"
  end

  create_table "artists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "includes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "playlist_id"
    t.string "track_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pos"
  end

  create_table "playlists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.boolean "collaborative"
    t.timestamp "modified_at"
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

  create_table "tracks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "uri"
    t.integer "duration"
    t.bigint "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "acousticness", limit: 24
    t.float "danceability", limit: 24
    t.integer "duration_ms"
    t.float "energy", limit: 24
    t.float "instrumentalness", limit: 24
    t.integer "key"
    t.float "liveness", limit: 24
    t.float "loudness", limit: 24
    t.integer "mode"
    t.float "speechiness", limit: 24
    t.float "tempo", limit: 24
    t.integer "time_signature"
    t.float "valence", limit: 24
    t.index ["album_id"], name: "index_tracks_on_album_id"
  end

  add_foreign_key "albums", "artists"
  add_foreign_key "tracks", "albums"
end
