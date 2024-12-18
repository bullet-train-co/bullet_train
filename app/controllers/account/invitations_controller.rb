class Account::InvitationsController < Account::ApplicationController
  include Account::Invitations::ControllerBase

  private

  def permitted_membership_fields
    # We render app/views/account/memberships/_attributes.html.erb on the Invitation form
    # so by default we permit all of the fields that the MembershipController permits. If
    # you want more control you can remove the following line and then return an array of
    # membership attributes that you want to allow at the time of iniviation. For example:
    # [ :description ]
    Account::MembershipsController.new.send(:permitted_fields)
  end
end
