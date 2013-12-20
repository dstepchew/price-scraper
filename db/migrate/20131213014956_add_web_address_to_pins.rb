class AddWebAddressToPins < ActiveRecord::Migration
  def change
    add_column :pins, :web_address, :string
    add_index :pins, :web_address
  end
end
