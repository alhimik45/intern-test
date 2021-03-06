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
    status = current_user.status @product
    if status[:can_buy]
      begin
        results = BuyService.new.buy
      rescue BadTimeoutError
        flash[:alert] = 'Не удалось выполнить покупку: важный сервис не отвечает'
        BuyMailer.admins_report_timeout.deliver_now!
      rescue TimeoutError
        flash[:alert] = 'Не удалось выполнить покупку: сервис не отвечает'
      rescue BuyError
        flash[:alert] = 'При покупке произошла ошибка'
        BuyMailer.admins_buy_fail(current_user).deliver_now!
      else
        flash[:notice] = 'Покупка прошла успешно'
        BuyMailer.user_buy_success(current_user, results[:url]).deliver_now!
        BuyMailer.admins_buy_success(results[:todo_id]).deliver_now!
      end
    else
      flash[:alert] = status[:error]
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

end
