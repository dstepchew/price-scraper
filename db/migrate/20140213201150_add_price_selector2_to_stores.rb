class AddPriceSelector2ToStores < ActiveRecord::Migration
  def change
    add_column :stores, :price_selector_2, :string
  end
end
