namespace :scrap do
  task :price_update => :environment do
    Pin.all.each do |pin|
      begin
        pin_url = pin.url
        pin_domain = URI.parse(pin_url).host
        store = Store.find_by_url(pin_domain)

        agent = Mechanize.new
        page = agent.get(pin_url)
        product_price = pin.product.price

        unless store.sales_price_selector.blank?
          product_price = page.search(store.sales_price_selector).first.text.match(/\b\d[\d,.]*\b/).to_s.to_f
        else
          product_price = page.search(store.price_selector).first.text.match(/\b\d[\d,.]*\b/).to_s.to_f
        end

        if product_price.to_f != pin.product.price.to_f
          ProductPriceUpdate.create(
            pin_id: pin.id,
            previous_price: pin.product.price,
            updated_price: product_price,
            status: 'pending'
          )
          #pin.product.update_attribute(:price, product_price)
        end
      rescue => exp
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
end