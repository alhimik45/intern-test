class ProductController < ApplicationController
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    p = post_params
    unless p['photo'].nil?
      path = upload_path p['photo']
      File.open('public' + path, "wb") { |f| f.write(p['photo'].tempfile.read) }
      p['photo'] = path
    end
    @product = Product.new p
    @product.save!
    redirect_to :back
  end

  def show
  end

  def delete
  end

  private
  def post_params
    params.require(:product).permit(:name, :description, :photo)
  end

  def upload_path file
    dir = '/upload/'
    file_extension = file.original_filename.split('.')[-1]
    filename = (0...32).map { (65 + rand(26)).chr }.join
    dir + filename + '.' + file_extension
  end

end
