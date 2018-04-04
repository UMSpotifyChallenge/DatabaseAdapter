class AddAudioFeaturesToTrack < ActiveRecord::Migration[5.1]
  def change
    add_column :tracks, :acousticness, :float
    add_column :tracks, :danceability, :float
    add_column :tracks, :duration_ms, :integer
    add_column :tracks, :energy, :float
    add_column :tracks, :instrumentalness, :float
    add_column :tracks, :key, :int
    add_column :tracks, :liveness, :float
    add_column :tracks, :loudness, :float
    add_column :tracks, :mode, :int
    add_column :tracks, :speechiness, :float
    add_column :tracks, :tempo, :float
    add_column :tracks, :time_signature, :int
    add_column :tracks, :valence, :float
  end
end
