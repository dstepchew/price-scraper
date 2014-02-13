class PriceUpdate < ActionMailer::Base
  default from: "dstepchew@gmail.com"

  def user_notification(price_update)
    @price_update = price_update

    mail( to: @price_update.pin.user.email, subject: 'Price updated')
  end
end
