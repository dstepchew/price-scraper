class Pin < ActiveRecord::Base
     belongs_to :user
     belongs_to :product
     belongs_to :store
     validates_presence_of :product, :store
  	 validates :description, presence: true
     has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end