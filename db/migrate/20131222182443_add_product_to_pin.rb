class AddProductToPin < ActiveRecord::Migration
  def change
  	add_column :pins, :Product_id, :integer
  end
end
