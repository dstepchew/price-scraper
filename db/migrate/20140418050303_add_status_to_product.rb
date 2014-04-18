class AddStatusToProduct < ActiveRecord::Migration
  def change
    add_column :products, :status, :string, default: "Active"

    Product.all.each do |product|
      product.update_attribute(:status, 'Active')
    end
  end
end
