class ProductsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]
  before_filter :check_admin, only: [:toggle_pro]
  before_filter :check_shop, only: [:new, :create]
  before_filter :check_owner, only: [:edit, :update, :destroy]

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

  def toggle_pro
    @product = Product.find params[:id]
    @product.pro = !@product.pro
    @product.save!
    redirect_to :back
  end

  private
  def post_params
    params.require(:product).permit(:name, :description, :photo)
  end

  def check_admin
    unless current_user.is_a? Admin
      redirect_to :back
    end
  end

  def check_shop
    unless current_user.is_a? Shop
      redirect_to :back
    end
  end

  def check_owner
    product = Product.find params[:id]
    if product.user != current_user
      redirect_to :back
    end
  end

end
