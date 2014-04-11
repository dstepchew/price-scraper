class ChangePinUrlToText < ActiveRecord::Migration
  def self.up
    change_column :pins, :url, :text, :limit => nil
  end

  def self.down
    change_column :pins, :url, :string
  end
end



