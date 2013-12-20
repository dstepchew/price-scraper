class AddStoreIdentificationToProducts < ActiveRecord::Migration
  def change
    add_column :products, :Store_id, :integer
    add_index :products, :Store_id
  end
end
