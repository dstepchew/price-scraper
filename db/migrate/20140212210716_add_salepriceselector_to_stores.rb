class AddSalepriceselectorToStores < ActiveRecord::Migration
  def change
    add_column :stores, :salepriceselector, :string
  end
end
