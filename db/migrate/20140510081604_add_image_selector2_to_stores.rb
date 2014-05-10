class AddImageSelector2ToStores < ActiveRecord::Migration
  def change
    add_column :stores, :image_selector_2, :string
  end
end
