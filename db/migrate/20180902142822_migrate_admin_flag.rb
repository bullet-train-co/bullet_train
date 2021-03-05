class MigrateAdminFlag < ActiveRecord::Migration[5.2]
  def up
    Membership.where(admin: true).each do |membership|
      membership.roles = [Role.admin]
      membership.save
    end
  end

  def down
    MembershipRole.where(role: Role.admin).each do |membership_role|
      membership_role.membership.update_column(:admin, true)
    end
  end
end
