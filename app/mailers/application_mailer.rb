class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAIL_EMAIL']
  layout 'mailer'
end
