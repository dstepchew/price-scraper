class ChangeProductImgurlToText < ActiveRecord::Migration
  def self.up
    change_column :products, :imageurl, :text, :limit => nil
  end

  def self.down
    change_column :products, :imageurl, :string
  end
end
