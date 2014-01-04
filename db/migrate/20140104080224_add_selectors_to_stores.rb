class AddSelectorsToStores < ActiveRecord::Migration
  def change
    add_column :stores, :name_selector, :string
    add_column :stores, :price_selector, :string
    add_column :stores, :image_selector, :string
  end
end
