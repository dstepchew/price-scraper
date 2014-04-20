class ChangeWebAddressToText < ActiveRecord::Migration
 def self.up
    change_column :pins, :web_address, :text, :limit => nil
  end

  def self.down
    change_column :pins, :web_address, :string
  end
end
