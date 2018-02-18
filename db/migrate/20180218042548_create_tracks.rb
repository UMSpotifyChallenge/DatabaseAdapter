class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks, id: false do |t|
      t.string :track_name
      t.string :artist_name
      t.string :album_name
      t.string :track_uri, primary: true
      t.string :artist_uri
      t.string :album_uri
      t.integer :duration_ms

      t.timestamps
    end
    # add_index :tracks, :track_uri, unique: true
  end
end
