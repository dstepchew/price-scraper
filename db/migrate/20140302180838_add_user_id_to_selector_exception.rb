class AddUserIdToSelectorException < ActiveRecord::Migration
  def change
    add_column :selector_exceptions, :user_id, :integer
  end
end
