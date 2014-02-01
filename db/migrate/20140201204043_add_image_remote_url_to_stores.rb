class AddImageRemoteUrlToStores < ActiveRecord::Migration
  def change
    add_column :stores, :image_remote_url, :string
  end
end
