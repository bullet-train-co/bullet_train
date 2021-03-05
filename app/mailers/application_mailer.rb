class ApplicationMailer < ActionMailer::Base
  # you can make this whatever you want.
  default from: "#{I18n.t("application.name")} <#{I18n.t("application.support_email")}>"
  layout "mailer"

  helper :email
  helper :application
  helper :images
  helper "account/teams"
  helper "account/users"
  helper "account/locale"
  helper "fields/trix_editor"
end
