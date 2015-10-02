class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  has_many :products

  def status(product)
  	if product.pro
  		return {
  			can_buy: false,
  			error: 'Вы не можете купить PRO-товар'
  		}
  	end
  	if self.email.split('.')[-1] == 'com'
  		return {
  			can_buy: false,
  			error: 'У Вас плохой e-mail'
  		}
  	end
  	{can_buy: true}
  end

end
