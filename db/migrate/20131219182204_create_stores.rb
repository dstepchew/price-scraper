class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.integer :StoreId
      t.string :StoreTitle
      t.string :StoreUrl
      t.text :StoreDesc

      t.timestamps
    end
  end
end
