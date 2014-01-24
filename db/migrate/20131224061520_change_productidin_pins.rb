class ChangeProductidinPins < ActiveRecord::Migration
  def change
  	change_table :pins do |t|
      t.rename :Product_id, :product_id
  	end
  end
end
