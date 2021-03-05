class MigrateAdminFlagOnInvitations < ActiveRecord::Migration[5.2]
  def up
    Invitation.where(admin: true).each do |invitation|
      invitation.roles = [Role.admin]
      invitation.save
    end
  end

  def down
    InvitationRole.where(role: Role.admin).each do |invitation_role|
      invitation_role.invitation.update_column(:admin, true)
    end
  end
end
