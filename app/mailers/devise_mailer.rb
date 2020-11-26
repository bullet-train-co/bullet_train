class DeviseMailer < Devise::Mailer
  def headers_for(action, opts)
    headers = super(action, opts)
    if resource.full_name.present?
      headers[:to] = "\"#{resource.full_name}\" <#{resource.email}>"
      @email = headers[:to]
    end
    headers
  end
end
