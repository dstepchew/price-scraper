class AddSalesPriceSelectorToStore < ActiveRecord::Migration
  def change
    add_column :stores, :sales_price_selector, :string
  end
end
