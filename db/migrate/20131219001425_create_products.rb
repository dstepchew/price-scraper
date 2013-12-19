class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :ProdId
      t.string :ProdTitle
      t.text :ProdDesc
      t.string :ProdImageUrl
      t.string :ProdUrl
      t.decimal :ProdPrice
      t.decimal :CurrProdPrice

      t.timestamps
    end
  end
end
