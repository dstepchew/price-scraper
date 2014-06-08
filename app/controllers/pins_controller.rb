class PinsController < ApplicationController
  before_action :set_pin, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show]

  def index
   @pins = current_user.pins.order("created_at DESC").paginate(:page => params[:page], :per_page => 8)
  end

  def show
  end

  def new
    @pin = current_user.pins.build
    @products = Product.all
    @stores = Store.all
  end

  def edit
  end


  def create
    pin_url = params[:pin][:url].strip
    begin
      agent = Mechanize.new
      begin
        page = agent.get(pin_url)
      rescue => exp
        raise "Invalid product url"
      end
      store = get_store(pin_url)

      already_pinned = false
      current_user.pins.each do |prev_pin|
        already_pinned = true if prev_pin.product.url.to_s == pin_url.to_s
      end

      if already_pinned
        @pin = current_user.pins.build(pin_params)
        flash[:notice] = "You are already tracking this item."
        render action: :new
      else
        @pin = current_user.pins.build(pin_params)
        if store           
          @pin.store_id = store.id     
          product = nil
  
          Product.all.each do |prd|
            product = prd if prd.exact_url == pin_url
          end

          unless product
            product = generate_related_product(store, page, pin_url)
            @pin.image = open(product.imageurl)
            @pin.product_id = product.id
            if @pin.save
              redirect_to @pin, notice: "Lucky you! Marla is now tracking this item for you."
            else
              render action: 'new'
            end
          else
            @pin.product_id = product.id
            @pin.image = open(product.imageurl)
            if @pin.save
              redirect_to @pin, notice: "Lucky you! Marla is now tracking this item for you."
            else
              render action: 'new'
            end
          end
        else
          flash[:notice] = 'Marla has not visited this store yet, but she will soon. Please try another store.'
          render action: 'new'
        end
      end
    rescue => exp
      if exp.message == "Invalid product url"
        flash[:notice] = "Item url seems to be invalid..."
      else
        SelectorException.create(message: exp.message, url: pin_url, store_id: store.id,
          backtrace: exp.backtrace[0..5].join("<br/>"), user_id: current_user.id)
        notice_message = "Marla is having trouble with this item and she blames her daughter."
        notice_message = "Make sure you're on a product page and try again."
        flash[:notice] = notice_message
      end
      render action: 'new'
    end
  end

  def update
    if @pin.update(pin_params)
      redirect_to @pin, notice: 'Tracking was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @pin.destroy
    flash[:notice] = "Price tracking stopped successfully."
    redirect_to pins_url
  end

  private
    def get_store(pin_url)
      encoded_url = URI.encode(pin_url)
      pin_domain = URI.parse(encoded_url).host
      store = Store.where(status: 'Active').find_by_url(pin_domain)
    
      unless store
        pin_domain_frag = pin_domain.sub(/^https?\:\/\//, '').sub(/^www./,'')
        pin_domain_prefix = 'www.'
        pin_domain_no_sub_domain = pin_domain_prefix + pin_domain_frag
        store = Store.where(status: 'Active').find_by_url(pin_domain_no_sub_domain)
    
        #pin_domain_fragment = pin_domain.split(".")
        #pin_domain_without_sub_domain = pin_domain_fragment[1..-1].join(".")
        
        #store = Store.find_by_url(pin_domain_without_sub_domain)
      end
      store
    end
    
    def fetch_product_price(store, page)
      # product_price_str = nil
      product_price = nil
    
      #if store.sales_price_selector
      #  product_price = page.search(store.salepriceselector).first.text.match(/\b\d[\d.]*\b/).to_s.gsub(/[^\d.]/, '') if page.search(store.salepriceselector).first unless store.salepriceselector.nil?
      #  product_price = page.search(store.price_selector_2).first.text.match(/\b\d[\d.]*\b/).to_s.gsub(/[^\d.]/, '') if ( store.salepriceselector.nil? || product_price.nil? || product_price.blank? ) && page.search(store.price_selector_2).first 
      #  product_price = page.search(store.price_selector).first.text.match(/\b\d[\d.]*\b/).to_s.gsub(/[^\d.]/, '') if ( product_price.nil? || product_price.blank? ) && page.search(store.price_selector).first
      #else
      #  product_price = page.search(store.price_selector).first.text.match(/\b\d[\d.]*\b/).to_s.gsub(/[^\d.]/, '')
      #end
     
    
    
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
    end
    
    def generate_related_product(store, page, pin_url)
      product_price = fetch_product_price(store, page) 
      product_name  = page.search(store.name_selector).first.text
      product_imageurl = page.search(store.image_selector).first.attribute('src').value().to_s.gsub(/[\n ]/, "") if page.search(store.image_selector).first unless store.image_selector.nil?
      product_imageurl = page.search(store.image_selector_2).first.attribute('src').value().to_s.gsub(/[\n ]/, "") if ( store.image_selector.nil? || product_imageurl.nil? || product_imageurl.blank? ) 
    
      product_urlprefix = 'http://'
      product_urlprefix2 = 'http:'
      product_imageurl = product_urlprefix + store.url + product_imageurl if store.image_uses_relative_path
      product_imageurl = product_urlprefix2 + product_imageurl if store.image_uses_relative_path_2
    
      store_pin_url = pin_url + store.affiliate_code
    
      Product.create!(
        url: store_pin_url,
        store_id: store.id,
        price: product_price,
        name: product_name,
        imageurl: product_imageurl
      )
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_pin
      @pin = Pin.find(params[:id])
    end

    def correct_user
      @pin = current_user.pins.find_by(id: params[:id])
      redirect_to pins_path, notice: "Not authorized to edit this tracking" if @pin.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pin_params
      params.require(:pin).permit(:description, :image, :product_id, :store_id, :url, product_attributes: [:id, :name, :description, :price, :imageurl, :url], store_attributes: [:id, :name, :description, :url, :affiliate_code])
    end
end
