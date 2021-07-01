class ProductsController < ApplicationController
    def index
        @products = Product.all
      end
    
      def search
        @product = Product.where('name ILIKE ?', '%' + params[:q] + '%').last
      end
    
      def show
        @product = Product.find(params[:id])
      end
    
      def new
        @product = Product.new
      end
    
      def create
        @product = Product.new(product_params)
    
        if @product.save
          flash[:success] = 'Сохранено'
          redirect_to @product
        else
          render :new
        end
      end
    
      def edit
        @product = Product.find(params[:id])
      end
    
      def update
        @product = Product.find(params[:id])
    
        if @product.update(product_params)
          flash[:success] = 'Обновлено'
          redirect_to @product
        else
          render :edit
        end
      end
    
      def destroy
        @product = Product.find(params[:id])
        @product.destroy
    
        redirect_to root_path
      end
    
      private
    
      def product_params
        params.require(:product).permit(:name, :category, :image)
      end
end
