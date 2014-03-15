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
    @pin = current_user.pins.build(pin_params)
    pin_url = params[:pin][:url]

    pin_domain = URI.parse(pin_url).host

    store = Store.find_by_url(pin_domain)
    if store
      @pin.store_id = store.id

      product = Product.find_by_url(pin_url)

      unless product
        begin
          agent = Mechanize.new
          page = agent.get(pin_url)
          product_price = nil

          if store.sales_price_selector
            product_price = page.search(store.price_selector_2).first.text.match(/\b\d[\d,.]*\b/).to_s.to_f if page.search(store.price_selector_2).first
            product_price = page.search(store.price_selector).first.text.match(/\b\d[\d,.]*\b/).to_s.to_f if ( product_price.nil? || product_price.blank? ) && page.search(store.price_selector).first
          else
            product_price = page.search(store.price_selector).first.text.match(/\b\d[\d,.]*\b/).to_s.to_f
          end

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
          SelectorException.create(
              message: exp.message,
              url: pin_url,
              store_id: store.id,
              backtrace: exp.backtrace[0..5].join("<br/>"),
              user_id: current_user.id
          )
          flash[:notice] = "Marla is having trouble with this item. She has notified her son in law to fix this problem right away so try again soon."
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
      flash[:notice] = 'This store is not in our database, please contact us to add this store before you can create this pin.'
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