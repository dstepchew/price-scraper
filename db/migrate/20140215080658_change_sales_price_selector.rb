class ChangeSalesPriceSelector < ActiveRecord::Migration
  def self.up
    change_column :stores, :sales_price_selector, 'boolean USING CAST(sales_price_selector AS boolean)'
  end

  def self.down
    change_column :stores, :sales_price_selector, :string
  end
end
