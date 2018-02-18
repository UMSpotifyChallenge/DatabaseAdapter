class AddPosToInclude < ActiveRecord::Migration[5.1]
  def change
    add_column :includes, :pos, :integer
  end
end
