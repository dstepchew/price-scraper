class ChangeStoreIdInProducts < ActiveRecord::Migration
  def change
  	change_table :Products do |t|
      t.rename :Store_id, :store_id
  	end
  end
end
