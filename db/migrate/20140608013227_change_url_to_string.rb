class ChangeUrlToString < ActiveRecord::Migration
  def change
    change_column :products, :url, :string, length: 1000
  end
end
