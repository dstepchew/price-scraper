class Pin < ActiveRecord::Base
     belongs_to :user
     belongs_to :product
     belongs_to :store

     has_many :product_price_updates

     validates_presence_of :product, :store
  	 validates :description, presence: true
     has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end