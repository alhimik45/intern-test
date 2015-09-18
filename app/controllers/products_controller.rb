class ProductsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :delete, :update, :create]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    p = post_params
    p['photo'] = save_photo p['photo']
    @product = Product.new p
    @product.save!
    current_user.products << @product
    redirect_to :back
  end

  def show
  end

  def delete
  end

  def edit
    @product = Product.find params[:id]
  end

  def update
    @product = Product.find params[:id]
    p = post_params
    unless p['photo'].nil?
      unless @product.photo.nil?
        File.delete('public' + @product.photo)
      end
      p['photo'] = save_photo p['photo']
    end
    @product.update!(p)
    redirect_to :back
  end

  private
  def post_params
    params.require(:product).permit(:name, :description, :photo)
  end

  def upload_path(file)
    dir = '/upload/'
    file_extension = file.original_filename.split('.')[-1]
    filename = (0...32).map { (65 + rand(26)).chr }.join
    dir + filename + '.' + file_extension
  end

  def save_photo(photo)
    unless photo.nil?
      path = upload_path photo
      File.open('public' + path, 'wb') { |f| f.write(photo.tempfile.read) }
      path
    end
  end

end
