class AddStartTrackToPlaylist < ActiveRecord::Migration[5.1]
  def change
    add_column :playlists, :start, :integer
  end
end
