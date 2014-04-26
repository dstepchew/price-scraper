      class ProductsController < ApplicationController
        before_action :set_product, only: [:show, :edit, :update, :destroy, :track]
        before_action :authenticate_user!, except: [:index, :show]
        before_filter :require_admin, except: [:index, :show, :track]

        # GET /products
        # GET /products.json
        def index
          if current_user && current_user.admin?
            @products = Product.order("created_at DESC").paginate(:page => params[:page], :per_page => 6)
          else
            @products = Product.where(status: 'Active').order("created_at DESC").paginate(:page => params[:page], :per_page => 6)
          end
          respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @products }
            format.js
          end
        end

        # GET /products/1
        # GET /products/1.json
        def show
           @products = Product.all
           @stores = Store.all
        end

        # GET /products/new
        def new
          @product = Product.new
          @stores = Store.all
        end

        # GET /products/1/edit
        def edit
        end

        # POST /products
        # POST /products.json
        def create
          @product = Product.new(product_params)

          respond_to do |format|
            if @product.save
              format.html { redirect_to @product, notice: 'Product was successfully created.' }
              format.json { render action: 'show', status: :created, location: @product }
            else
              format.html { render action: 'new' }
              format.json { render json: @product.errors, status: :unprocessable_entity }
            end
          end
        end

        # PATCH/PUT /products/1
        # PATCH/PUT /products/1.json
        def update
          respond_to do |format|
            if @product.update(product_params)
              format.html { redirect_to @product, notice: 'Product was successfully updated.' }
              format.json { head :no_content }
            else
              format.html { render action: 'edit' }
              format.json { render json: @product.errors, status: :unprocessable_entity }
            end
          end
        end

        # DELETE /products/1
        # DELETE /products/1.json
        def destroy
          @product.destroy
          respond_to do |format|
            format.html { redirect_to products_url }
            format.json { head :no_content }
          end
        end

        def track
          pin = Pin.new(
            description: 'Fast Tracked By Marla',
            user_id: current_user.id,
            web_address: @product.url,
            url: @product.url,
            product_id: @product.id,
            store_id: @product.store.id,
            image: @product.imageurl
          )

          respond_to do |format|
            if pin.save
              format.html { redirect_to products_path, notice: 'Lucky you! Marla is now tracking this item for you. Visit Your Items to add a description.' }
              format.json { head :no_content }
            else
              format.html { render action: 'edit' }
              format.json { render json: pin.errors, status: :unprocessable_entity }
            end
          end
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_product
            @product = Product.find(params[:id])
          end

          # Never trust parameters from the scary internet, only allow the white list through.
          def product_params
            params.require(:product).permit(
              :name, :description, :imageurl, :url, :price, :status, :store_id,
              store_attributes: [
                 :id, :name, :description, :product_selector,
                :name_selector, :price_selector, :price_selector_2, :salepriceselector, :image_selector
              ],
              pin_attributes: [
                 :id, :user_id, :description
              ]
            )
          end
      end
