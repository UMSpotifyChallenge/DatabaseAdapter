class RemoveDurationFromTrack < ActiveRecord::Migration[5.1]
  def change
    remove_column :tracks, :duration, :integer
  end
end
