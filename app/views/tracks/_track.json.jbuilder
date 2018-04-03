json.extract! track, :id, :name, :uri, :duration, :album_id, :created_at, :updated_at
json.url track_url(track, format: :json)
