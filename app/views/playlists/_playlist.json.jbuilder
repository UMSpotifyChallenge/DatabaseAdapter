json.extract! playlist, :id, :name, :collaborative, :modified_at, :num_tracks, :num_albums, :num_followers, :num_edits, :duration_ms, :num_artists, :created_at, :updated_at
json.url playlist_url(playlist, format: :json)
