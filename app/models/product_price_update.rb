class ProductPriceUpdate < ActiveRecord::Base
  belongs_to :pin

  default_scope order('created_at DESC')
  
end
