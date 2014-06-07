namespace :scrap do
  task :price_update => :environment do
    Pin.all.each do |pin|
      next if pin.product.status == "Inactive"
      sleep 5
      begin
        if pin.validate_selectors
          pin_url = pin.url

            encoded_url = URI.encode(pin_url)
            pin_domain = URI.parse(encoded_url).host

        #  store = Store.find_by_url(pin_domain)

            store = Store.where(status: 'Active').find_by_url(pin_domain)

          unless store
          pin_domain_frag = pin_domain.sub(/^https?\:\/\//, '').sub(/^www./,'')
          pin_domain_prefix = 'www.'
          pin_domain_no_sub_domain = pin_domain_prefix + pin_domain_frag
          store = Store.where(status: 'Active').find_by_url(pin_domain_no_sub_domain)
          end

          agent = Mechanize.new
          page = agent.get(encoded_url)

          
                if store.sales_price_selector
                  product_price_str = page.search(store.salepriceselector).first.text.match(/\b\d[\d,.]*\b/).to_s.gsub(/[^\d.]/, '') if page.search(store.salepriceselector).first unless store.salepriceselector.nil?
                  product_price_str = page.search(store.price_selector_2).first.text.match(/\b\d[\d,.]*\b/).to_s.gsub(/[^\d.]/, '') if ( store.salepriceselector.nil? || product_price_str.nil? || product_price_str.blank? ) && page.search(store.price_selector_2).first 
                  product_price_str = page.search(store.price_selector).first.text.match(/\b\d[\d,.]*\b/).to_s.gsub(/[^\d.]/, '') if ( product_price_str.nil? || product_price_str.blank? ) && page.search(store.price_selector).first
                 else
                  product_price_str = page.search(store.price_selector).first.text.match(/\b\d[\d,.]*\b/).to_s.gsub(/[^\d.]/, '')
                 end
                product_price_str_decimal = "00"
                product_price_str_decimal = product_price_str.split(".")[1] if product_price_str.split(".")[1] 
                
                product_price_str = product_price_str.split(".")[0]
                
                #product_price_str_new = product_price_str.scan(/\d[\d,.]/).join('') 
                product_price = product_price_str + "." + product_price_str_decimal

          if !product_price.blank? && product_price.to_f != pin.product.price.to_f
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
   
   #recommended change
     price_updates = ProductPriceUpdate.where(status: 'pending')
      PriceUpdate.user_notification(price_updates).deliver!
      price_updates.each do |price_update|
        price_update.update_attribute(:status, 'notified')
      end

#old

  # ProductPriceUpdate.where(status: 'pending').each do |price_update|
   # PriceUpdate.user_notification(price_update).deliver!
   # price_update.update_attribute(:status, 'notified')
  # end
  end

  task :activate_products => :environment do
    Product.all.each do |product|
     product.update_attribute(:status, 'Active')
     end

   end

   task :remove_updates => :environment do
    ProductPriceUpdate.destroy_all
  end

end