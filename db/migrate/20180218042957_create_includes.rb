class CreateIncludes < ActiveRecord::Migration[5.1]
  def change
    create_table :includes do |t|
      t.integer :playlist_id
      t.integer :track_id

      t.timestamps
    end
  end
end
