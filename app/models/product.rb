		class Product < ActiveRecord::Base

			belongs_to :store
			validates_presence_of :name, :url, :price
			has_many :pins

		end
