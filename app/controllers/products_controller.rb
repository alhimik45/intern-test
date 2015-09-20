class ProductsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find params[:id]
  end

  def new
    @product = Product.new
  end

  def create
    p = post_params
    @product = Product.new p
    @product.save!
    current_user.products << @product
    redirect_to :root
  end

  def edit
    @product = Product.find params[:id]
  end

  def update
    @product = Product.find params[:id]
    p = post_params

    @product.update!(p)
    redirect_to :back
  end

  def destroy
    @product = Product.find params[:id]
    @product.destroy!
    redirect_to :root
  end

  private
  def post_params
    params.require(:product).permit(:name, :description, :photo)
  end


end
