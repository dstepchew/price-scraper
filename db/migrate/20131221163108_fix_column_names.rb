class FixColumnNames < ActiveRecord::Migration
  def change
  	change_table :products do |t|
      t.rename :ProdTitle, :name
      t.rename :ProdDesc, :description
      t.rename :ProdImageUrl, :imageurl 
      t.rename :ProdUrl, :url 
      t.rename :ProdPrice, :price 
      t.remove :CurrProdPrice
      t.remove :StoreTitle
      t.remove :ProdId
    end
  end
end
