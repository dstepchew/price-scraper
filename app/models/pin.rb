class Pin < ActiveRecord::Base
     belongs_to :user
     belongs_to :product
     belongs_to :store

     has_many :product_price_updates, dependent: :destroy

     validates_presence_of :product, :store
  	 validates :description, presence: true
     has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }

     def validate_selectors
       begin
         agent = Mechanize.new
         page = agent.get(self.url)
         product_price = nil

         message = nil
         if store.sales_price_selector
           begin
             product_price = page.search(store.price_selector_2).first.text.match(/\b\d[\d,.]*\b/).to_s.to_f if page.search(store.price_selector_2).first
           rescue => exp
             message = "Exception in retrieving price_selector_2"
           end

           begin
             product_price = page.search(store.price_selector).first.text.match(/\b\d[\d,.]*\b/).to_s.to_f if ( product_price.nil? || product_price.blank? ) && page.search(store.price_selector).first
           rescue => exp
             message = "Exception in retrieving price_selector"
           end
         else
           begin
             product_price = page.search(store.price_selector).first.text.match(/\b\d[\d,.]*\b/).to_s.to_f
           rescue => exp
             message = "Exception in retrieving price selector"
           end
         end

         begin
           product_name  = page.search(store.name_selector).first.text
         rescue => exp
           message = "Exception in retrieving product name"
         end

         begin
           product_image_url = page.search(store.image_selector).first.attribute('src').value
         rescue => exp
           message = "Exception in retrieving product image url"
         end
         if message.nil?
           true
         else
           SelectorException.create(
               message: message,
               url: self.url,
               store_id: self.store.id,
               backtrace: exp.backtrace[0..5].join("<br/>"),
               user_id: self.user_id
           )
           false
         end
       rescue => exp
         SelectorException.create(
             message: exp.message,
             url: self.url,
             store_id: self.store.id,
             backtrace: exp.backtrace[0..5].join("<br/>"),
             user_id: self.user_id
         )
         false
       end
     end
end