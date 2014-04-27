class AddUsedRelativePathToStore2 < ActiveRecord::Migration
 def change
    add_column :stores, :image_uses_relative_path_2, :boolean
  end
end
