class Product < ActiveRecord::Base

	belongs_to :store
	validates_presence_of :name, :url, :price


end
