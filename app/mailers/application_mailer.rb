class ApplicationMailer < ActionMailer::Base

  # you can make this whatever you want.
  default from: "#{I18n.t('application.name')} <#{I18n.t('application.support_email')}>"
  layout 'mailer'

  add_template_helper(EmailHelper)
  add_template_helper(ApplicationHelper)
  add_template_helper(ImagesHelper)
  add_template_helper(Account::TeamsHelper)
  add_template_helper(Account::UsersHelper)
  add_template_helper(Fields::TrixEditorHelper)

end
