class AddStatusToStore < ActiveRecord::Migration
  def change
    add_column :stores, :status, :string, default: 'Active'
  end
end
