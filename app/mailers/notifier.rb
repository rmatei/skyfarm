class Notifier < ActionMailer::Base
  default :from => 'bot@skyfarmsf.com'

  def bill(payment)
    @payment = payment
    @user = payment.user
    @billing_period = payment.billing_period
    mail(:to => @user.email,
         :subject => "Skyfarm bill for #{payment.billing_period.to_label}",
         :reply_to => "rmatei@gmail.com",
         :bcc => ["rmatei@gmail.com", "bot@skyfarmsf.com"])
  end
end
