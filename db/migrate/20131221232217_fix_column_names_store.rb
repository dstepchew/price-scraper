class FixColumnNamesStore < ActiveRecord::Migration
  def change
  	change_table :Stores do |t|
      t.rename :StoreTitle, :name
      t.rename :StoreDesc, :description
      t.rename :StoreUrl, :url 
      t.remove :StoreId
  	end
  end
end
