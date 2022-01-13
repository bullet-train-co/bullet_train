Warden::Manager.after_authentication do |user, auth, options|
  Current.user = user
end

Warden::Manager.before_logout do |user, auth, options|
  Current.user = nil
end
