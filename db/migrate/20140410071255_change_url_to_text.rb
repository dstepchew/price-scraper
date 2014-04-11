class ChangeUrlToText < ActiveRecord::Migration
  def up
    change_column :products, :url, :text, :limit => nil
end
def down
    change_column :products, :url, :string
end
end
