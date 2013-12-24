class ChangeProductidinPins < ActiveRecord::Migration
  def change
  	change_table :Pins do |t|
      t.rename :Product_id, :product_id
  	end
  end
end
