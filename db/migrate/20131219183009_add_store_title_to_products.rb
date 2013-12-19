class AddStoreTitleToProducts < ActiveRecord::Migration
  def change
    add_column :products, :StoreTitle, :string
    add_index :products, :StoreTitle
  end
end
