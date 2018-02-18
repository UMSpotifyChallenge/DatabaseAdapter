json.extract! track, :id, :track_name, :artist_name, :album_name, :track_uri, :artist_uri, :album_uri, :duration_ms, :created_at, :updated_at
json.url track_url(track, format: :json)
