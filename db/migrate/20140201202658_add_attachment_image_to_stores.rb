class AddAttachmentImageToStores < ActiveRecord::Migration
  def self.up
    change_table :stores do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :stores, :image
  end
end
