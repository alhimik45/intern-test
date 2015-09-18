class ProductController < ApplicationController
  def index
    @products = Product.all
  end

  def create
  end

  def show
  end

  def delete
  end
end
