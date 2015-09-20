class ProductsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]
  before_filter :check_admin, only: [:toggle_pro]
  before_filter :check_shop, only: [:new, :create]
  before_filter :check_guest, only: [:buy]
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

  def buy
    @product = Product.find params[:id]
    user_can_buy = true
    if @product.pro
      user_can_buy = false
      flash[:alert] = 'Вы не можете купить PRO-товар'
    end
    if current_user.email.split('.')[-1] == 'com'
      user_can_buy = false
      flash[:alert] = 'У Вас плохой e-mail'
    end
    if user_can_buy
      begin
        photos = get_photos
      rescue TimeoutError
        flash[:alert] = 'Не удалось выполнить покупку: сервис не отвечает'
      else
        photo = JSON.parse(photos).sample
        thumbnail = photo['thumbnailUrl']
        url = photo['url']
        thumbnail_color = thumbnail.split('/')[-1].to_i 16
        url_color = url.split('/')[-1].to_i 16
        if thumbnail_color > url_color
          flash[:alert] = 'При покупке произошла ошибка'
          BuyMailer.admins_buy_fail(current_user).deliver_now!
        else
          begin
            todos = get_todos
          rescue TimeoutError
            flash[:alert] = 'Не удалось выполнить покупку: сервис не отвечает'
            BuyMailer.admins_report_timeout.deliver_now!
          else
            todo_id = JSON.parse(todos)['id']
            flash[:notice] = 'Покупка прошла успешно'
            BuyMailer.user_buy_success(current_user, url).deliver_now!
            BuyMailer.admins_buy_success(todo_id).deliver_now!
          end

        end
      end
    end
    redirect_to :back
  end


  private
  def post_params
    params.require(:product).permit(:name, :description, :photo)
  end

  def check_admin
    check_role Admin
  end

  def check_shop
    check_role Shop
  end

  def check_guest
    check_role Guest
  end

  def check_role(role)
    unless current_user.is_a? role
      flash[:alert] = 'У Вас не тот тип аккаунта'
      redirect_to :back
    end
  end

  def check_owner
    product = Product.find params[:id]
    if product.user != current_user
      redirect_to :back
    end
  end

  def get_photos
    Timeout::timeout(3) {
      sleep(rand 6)
      RestClient.get 'http://jsonplaceholder.typicode.com/photos/'
    }
  end

  def get_todos
    3.times {
      begin
        Timeout::timeout(3) {
          sleep(rand 6)
          return RestClient.post 'http://jsonplaceholder.typicode.com/todos', {}
        }
      rescue
      end
    }
    raise TimeoutError
  end

end
