class UpdateMembershipsEmailToMatchUsers < ActiveRecord::Migration[8.0]
  def up
    # Conceptually this migraiton is doing this:
    # User.find_each do |user|
    #  user.memberships.where.not(user_email: user.email).update(user_email: user.email)
    # end

    # But instead of looping all Users we're looking specifically for Memberships where `user_email`
    # doesn't match the `email` column from the associated user.
    memberships_to_update = Membership.joins(:user).includes(:user)
      .where("memberships.user_email != users.email")

    # Then we loop the memberships that need updating and call `update` on each one individually
    # so that `updated_at` will be set for us and so that ActiveRecord callbacks will run.
    # If you don't want either of those things and would prefer to update all memberships in a
    # single SQL comment out this block, or remove it, and see the block below.
    memberships_to_update.find_each do |membership|
      membership.update(user_email: membership.user.email)
    end

    # If you want to update all memberships in a single SQL call comment out the `find_each` block above
    # and uncomment the line below. Note that callbacks will not run, and `updated_at` will not be set.
    # memberships_to_update.update_all('user_email = (select users.email from users where users.id = memberships.user_id)')
  end

  def down
  end
end
