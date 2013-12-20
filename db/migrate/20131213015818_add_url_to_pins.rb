class AddUrlToPins < ActiveRecord::Migration
  def change
    add_column :pins, :url, :string
    add_index :pins, :url
  end
end
