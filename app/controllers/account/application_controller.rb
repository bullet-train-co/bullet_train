class Account::ApplicationController < ApplicationController
  include Account::Controllers::Base

  def ensure_onboarding_is_complete
    # First check that Bullet Train doesn't have any onboarding steps it needs to enforce.
    return false unless super

    # Most onboarding steps you'll add should be skipped if the user is adding a team or accepting an invitation ...
    unless adding_team? || accepting_invitation?
      # So, if you have new onboarding steps to check for an enforce, do that here:
    end

    # Finally, if we've gotten this far, then onboarding appears to be complete!
    true
  end
end
