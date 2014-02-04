class AddUsedRelativePathToStore < ActiveRecord::Migration
  def change
    add_column :stores, :image_uses_relative_path, :boolean
  end
end
