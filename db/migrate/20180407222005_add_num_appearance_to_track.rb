class AddNumAppearanceToTrack < ActiveRecord::Migration[5.1]
  def change
    add_column :tracks, :num_appearances, :integer
  end
end
