		class Product < ActiveRecord::Base

			belongs_to :store
			validates_presence_of :url, :price, :name
      has_many :pins
      has_many :product_price_updates, through: :pins
			accepts_nested_attributes_for :pins


			#private
			#url = "http://www.medelita.com/lab-coat-callia.html"
        	#doc = Nokogiri::HTML(open(url))
        	#doc.css("store.product_selector").each do |item|
          		#ptitle = item.at_css("store.name_selector").text
          		#pprice = item.at_css("store.price_selector").text[/\$[0-9\.]+/]
          		
        	#end

		end
