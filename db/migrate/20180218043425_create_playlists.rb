class CreatePlaylists < ActiveRecord::Migration[5.1]
  def change
    create_table :playlists do |t|
      t.string :name
      t.boolean :collaborative
      t.timestamp :modified_at
      t.integer :num_tracks
      t.integer :num_albums
      t.integer :num_followers
      t.integer :num_edits
      t.integer :duration_ms
      t.integer :num_artists
      t.text :description

      t.timestamps
    end
  end
end
