class ChangePinImageFileNameToText < ActiveRecord::Migration
  def self.up
    change_column :pins, :image_file_name, :text, :limit => nil
  end

  def self.down
    change_column :pins, :image_file_name, :string
  end
end
