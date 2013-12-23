class Pin < ActiveRecord::Base
     belongs_to :user
     has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
     has_one :product
     has_one :store, through: :products
end