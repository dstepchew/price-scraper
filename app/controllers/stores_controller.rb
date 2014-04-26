      class StoresController < ApplicationController
        before_action :set_store, only: [:show, :edit, :update, :destroy]
        before_action :authenticate_user!, except: [:index, :show]
        before_filter :require_admin, except: [:index, :show]

        # GET /stores
        # GET /stores.json
        def index
          if current_user && current_user.admin?
             @search = Store.search(params[:q])
            @stores = @search.result
          else
            @search = Store.where(status: 'Active').search(params[:q])
            @stores = @search.result.limit(50)
            #@stores = Store.where(status: 'Active').includes(:products).paginate(:page => params[:page], :per_page => 8)
          end
         
            if @search.result.count >= 200
              redirect_to stores_path, notice: "Please Narrow Your Search"
            elsif @search.result.count == 0
              redirect_to stores_path, notice: "Sorry friend! None of our stores match your search. Perhaps try suggesting a store?"
            else
             true
          end
        end

        # GET /stores/1
        # GET /stores/1.json
        def show
          @products = Product.all
        end

        # GET /stores/new
        def new
          @store = Store.new
        end

        # GET /stores/1/edit
        def edit
        end

        # POST /stores
        # POST /stores.json
        def create
          @store = Store.new(store_params)

          def image_remote_url=(url_value)
            self.image = URI.parse(url_value) unless url_value.blank?
          super
          end

          respond_to do |format|
            if @store.save
              format.html { redirect_to @store, notice: 'Store was successfully created.' }
              format.json { render action: 'show', status: :created, location: @store }
            else
              format.html { render action: 'new' }
              format.json { render json: @store.errors, status: :unprocessable_entity }
            end
          end
        end

        # PATCH/PUT /stores/1
        # PATCH/PUT /stores/1.json
        def update
          respond_to do |format|
            if @store.update(store_params)
              format.html { redirect_to @store, notice: 'Store was successfully updated.' }
              format.json { head :no_content }
            else
              format.html { render action: 'edit' }
              format.json { render json: @store.errors, status: :unprocessable_entity }
            end
          end
        end

        # DELETE /stores/1
        # DELETE /stores/1.json
        def destroy
          @store.destroy
          respond_to do |format|
            format.html { redirect_to stores_url }
            format.json { head :no_content }
          end
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_store
            @store = Store.find(params[:id])
          end

          # Never trust parameters from the scary internet, only allow the white list through.
          def store_params
            params.require(:store).permit(:name, :url, :description, :image, :image_remote_url, :product_selector,
                                          :name_selector, :price_selector, :sales_price_selector, :price_selector_2,
                                          :image_selector, :image_uses_relative_path, :status,product_attributes: [:id, :name, :description, :price, :imageurl, :url])
          end
      end
