class Store < ActiveRecord::Base

	has_many :products
	has_many :pins, through: :products
	accepts_nested_attributes_for :products

end
