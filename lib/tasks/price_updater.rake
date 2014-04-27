namespace :scrap do
  task :price_update => :environment do
    Pin.all.each do |pin|
      next if pin.product.status == "Inactive"
      begin
        if pin.validate_selectors
          pin_url = pin.url

            encoded_url = URI.encode(pin_url)
            pin_domain = URI.parse(encoded_url).host

          store = Store.find_by_url(pin_domain)

          agent = Mechanize.new
          page = agent.get(encoded_url)
          



            if store.sales_price_selector
              product_price = page.search(store.salepriceselector).first.text.match(/\b\d[\d,.]*\b/) if page.search(store.salepriceselector).first unless store.salepriceselector.nil?
              product_price = page.search(store.price_selector_2).first.text.match(/\b\d[\d,.]*\b/) if ( store.salepriceselector.nil? || product_price.nil? || product_price.blank? ) && page.search(store.price_selector_2).first 
              product_price = page.search(store.price_selector).first.text.match(/\b\d[\d,.]*\b/) if ( product_price.nil? || product_price.blank? ) && page.search(store.price_selector).first
            else
              product_price = page.search(store.price_selector).first.text.match(/\b\d[\d,.]*\b/)
            end









          if !product_price.blank? && product_price != pin.product.price
            ProductPriceUpdate.create(
              pin_id: pin.id,
              previous_price: pin.product.price,
              updated_price: product_price,
              status: 'pending'
            )
            pin.product.update_attribute(:price, product_price)
          end
          pin.product.update_attribute(:status, 'Active')
        else
          pin.product.update_attribute(:status, 'Inactive')
        end

      rescue => exp
        pin.product.update_attribute(:status, 'Inactive')
        puts "Exception in retrieving updated price " + exp.message
      end

    end
  end

  task :notify_user => :environment do
    ProductPriceUpdate.where(status: 'pending').each do |price_update|
      PriceUpdate.user_notification(price_update).deliver!
      price_update.update_attribute(:status, 'notified')
    end
  end

  task :activate_products => :environment do

    
    Product.all.each do |product|
     product.update_attribute(:status, 'Active')
     end

   end

end