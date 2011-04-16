class Notifier < ActionMailer::Base
  default :from => 'bot@skyfarmsf.com'

  def bill(payment)
    @payment = payment
    @user = payment.user
    @billing_period = payment.billing_period
    mail(:to => "bot@skyfarmsf.com",#@user.email,
         :bcc => ["rmatei@gmail.com", "bot@skyfarmsf.com"])
  end
end
