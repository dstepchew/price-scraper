class Store < ActiveRecord::Base

	has_many :products
	has_many :pins
	accepts_nested_attributes_for :products, :allow_destroy => true
	accepts_nested_attributes_for :pins
	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  after_update :update_products

  def update_products
    products.each do |prod|
      prod.update_column(:status, self.status)
    end
  end
end
