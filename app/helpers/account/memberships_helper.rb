module Account::MembershipsHelper
  def membership_destroy_locale_key(membership)
    if membership.user == current_user
      ".destroy_own"
    else
      ".destroy"
    end
  end
end
