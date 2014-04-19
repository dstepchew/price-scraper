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
    pin_url = params[:pin][:url]

    encoded_url = URI.encode(pin_url)
    pin_domain = URI.parse(encoded_url).host
    store = Store.find_by_url(pin_domain)

    unless store
      pin_domain_fragment = pin_domain.split(".")
      pin_domain_without_sub_domain = pin_domain_fragment[1..-1].join(".")
      store = Store.find_by_url(pin_domain_without_sub_domain)
    end

    already_pinned = false
    current_user.pins.each do |prev_pin|
      already_pinned = true if prev_pin.product.url.to_s == pin_url.to_s
    end

    @pin = current_user.pins.build(pin_params)

    if already_pinned
      flash[:notice] = "You are already tracking this item."
      render action: :new
    else
      if store
        @pin.store_id = store.id

        product = Product.find_by_url(pin_url)

        unless product
          begin
            agent = Mechanize.new
            begin
              page = agent.get(pin_url)
            rescue => exp
              raise "Invalid product url"
            end
            product_price_str = nil
            product_price = nil

            if store.sales_price_selector
              product_price_str = page.search(store.price_selector_2).first.text.match(/\b\d[\d,.]*\b/).to_s if page.search(store.price_selector_2).first
              product_price_str = page.search(store.price_selector).first.text.match(/\b\d[\d,.]*\b/).to_s if ( product_price.nil? || product_price.blank? ) && page.search(store.price_selector).first
            else
              product_price_str = page.search(store.price_selector).first.text.match(/\b\d[\d,.]*\b/).to_s
            end
            product_price_str = product_price_str.split(".")[0]
            product_price = product_price_str.scan(/\d/).join('')

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
              redirect_to @pin, notice: "Lucky you! Marla is now tracking this item for you."
            else
              render action: 'new'
            end
          rescue => exp
            if exp.message == "Invalid product url"
              flash[:notice] = "Item url seems to be invalid..."
            else
              SelectorException.create(
                  message: exp.message,
                  url: pin_url,
                  store_id: store.id,
                  backtrace: exp.backtrace[0..5].join("<br/>"),
                  user_id: current_user.id
              )
              flash[:notice] = "Marla is having trouble with this item and she blames her daughter. Try again soon."
            end

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
      params.require(:pin).permit(:description, :image, :product_id, :store_id, :url, product_attributes: [:id, :name, :description, :price, :imageurl, :url], store_attributes: [:id, :name, :description, :url])
    end
end