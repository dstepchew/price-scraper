class AddStoreIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :StoreId, :integer
    add_index :products, :StoreId
  end
end
