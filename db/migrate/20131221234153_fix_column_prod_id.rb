class FixColumnProdId < ActiveRecord::Migration
  def change

  	change_table :products do |t|
      t.remove :StoreId
    end
  end
end
