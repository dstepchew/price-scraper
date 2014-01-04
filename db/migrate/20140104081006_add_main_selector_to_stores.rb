class AddMainSelectorToStores < ActiveRecord::Migration
  def change
    add_column :stores, :product_selector, :string
  end
end
