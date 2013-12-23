class FixColumnProdId < ActiveRecord::Migration
  def change

  	change_table :Products do |t|
      t.remove :StoreId
    end
  end
end
