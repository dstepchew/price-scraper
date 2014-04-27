class SelectorExceptionsController < ApplicationController

before_action :authenticate_user!
before_filter :require_admin

  def index
    @selector_exceptions = SelectorException.all
  end



   

  def retry_pin
    @selector_exception = SelectorException.find params[:id]

    pin_url = @selector_exception.url
    pin_domain = URI.parse(pin_url).host
    store = Store.find_by_url(pin_domain)

    @pin = Pin.new(
      url: @selector_exception.url,
      store_id: store.id,
      user_id: @selector_exception.user_id,
      description: "Restored by admin"
    )

    @selector_exception.destroy
    if @pin.validate_selectors

      begin
        agent = Mechanize.new
        page = agent.get(pin_url)
       #product_price_str = nil
            product_price = nil

            if store.sales_price_selector
              product_price = page.search(store.salepriceselector).first.text.match(/\b\d[\d.]*\b/) if page.search(store.salepriceselector).first unless store.salepriceselector.nil?
              product_price = page.search(store.price_selector_2).first.text.match(/\b\d[\d.]*\b/) if ( store.salepriceselector.nil? || product_price.nil? || product_price.blank? ) && page.search(store.price_selector_2).first 
              product_price = page.search(store.price_selector).first.text.match(/\b\d[\d.]*\b/) if ( product_price.nil? || product_price.blank? ) && page.search(store.price_selector).first
            else
              product_price = page.search(store.price_selector).first.text.match(/\b\d[\d.]*\b/)
            end
      #      product_price_str = product_price_str.split(".")[0]
      #      product_price = product_price_str.scan(/\d/).join('')


      #      if store.sales_price_selector
      #        product_price_str = page.search(store.salepriceselector).first.text.match(/\b\d[\d,.]*\b/).to_s if page.search(store.salepriceselector).first unless store.salepriceselector.nil?
      #        product_price_str = page.search(store.price_selector_2).first.text.match(/\b\d[\d,.]*\b/).to_s if ( store.salepriceselector.nil? || product_price_str.nil? || product_price_str.blank? ) && page.search(store.price_selector_2).first 
      #        product_price_str = page.search(store.price_selector).first.text.match(/\b\d[\d,.]*\b/).to_s if ( product_price_str.nil? || product_price_str.blank? ) && page.search(store.price_selector).first
      #      else
      #        product_price_str = page.search(store.price_selector).first.text.match(/\b\d[\d,.]*\b/).to_s
      #      end
      #      product_price_str = product_price_str.split(".")[0]
      #      product_price = product_price_str.scan(/\d/).join('')

        product_name  = page.search(store.name_selector).first.text
        product_imageurl = page.search(store.image_selector).first.attribute('src').value

        product_urlprefix = 'http://'
        product_imageurl = product_urlprefix + store.url + product_imageurl if store.image_uses_relative_path

        product = Product.create!(
          url: pin_url,
          store_id: store.id,
          price: product_price,
          name: product_name,
          imageurl: product_imageurl
        )

        @pin.image = open(product_imageurl)
        @pin.product_id = product.id
        if @pin.save
          redirect_to action: :index, notice: "Marla is now tracking this item."
        else
          redirect_to action: :index, notice: "Failed to load pin!"
        end
      rescue => exp
        flash[:notice] = "Failed to implement tracker on the product."
        redirect_to action: :index
      end
    else
      flash[:notice] = "Failed to implement tracker on the product."
      redirect_to action: :index
    end
  end

def destroy
   @selector_exception = SelectorException.find params[:id]
    @selector_exception.destroy
    redirect_to selector_exceptions_url
  end


end
