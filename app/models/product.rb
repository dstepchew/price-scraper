class Product < ActiveRecord::Base

	belongs_to :store
	# validates_presence_of :store


end
