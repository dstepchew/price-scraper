class AddUrlToSelectorException < ActiveRecord::Migration
  def change
    add_column :selector_exceptions, :url, :string
  end
end
