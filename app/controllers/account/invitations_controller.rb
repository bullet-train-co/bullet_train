class Account::InvitationsController < Account::ApplicationController
  include Account::Invitations::ControllerBase

  private

  def permitted_membership_fields
    [
      # 🚅 super scaffolding will insert new fields above this line.
    ]
  end
end
