class BuyMailer < ApplicationMailer

  def user_buy_success(user, photo_url)
    @url = photo_url
    mail(to: user.email, subject: 'Ваша покупка')
  end

  def admins_buy_success(product_id)
    @id = product_id
    mail(to: Admin.pluck(:email), subject: 'Пользователь купил товар')
  end

  def admins_buy_fail(user)
    @user = user
    mail(to: Admin.pluck(:email), subject: 'У пользователя произошла ошибка')
  end

  def admins_report_timeout
    mail(to: Admin.pluck(:email), subject: 'Сервисы не отвечают')
  end

end
