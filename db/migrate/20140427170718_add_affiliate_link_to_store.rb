class AddAffiliateLinkToStore < ActiveRecord::Migration
  def change
    add_column :stores, :affiliate_code, :string, :default => " "
  end
end
