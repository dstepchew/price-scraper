class ChangePinUrlToText < ActiveRecord::Migration
  def change

  	 def up
    change_column :pins, :url, :text, :limit => nil
    change_column :products, :imageurl, :text => nil
end
def down
    change_column :pins, :url, :string
    change_column :products, :imageurl, :string
end
  end
end
