class AddStoreIdToPins < ActiveRecord::Migration
  def change
    add_column :pins, :store_id, :integer
  end
end
