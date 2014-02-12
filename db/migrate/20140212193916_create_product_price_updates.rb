class CreateProductPriceUpdates < ActiveRecord::Migration
  def change
    create_table :product_price_updates do |t|
      t.integer :pin_id
      t.decimal :previous_price
      t.decimal :updated_price
      t.string :status

      t.timestamps
    end
  end
end
