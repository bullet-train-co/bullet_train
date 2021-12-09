class MigrateRoleIdsToYml < ActiveRecord::Migration[6.1]
  def up
    add_column :memberships, :role_ids, :jsonb, default: []
    migrating_role_ids = {}
    say_with_time "Creating #{yml_file_path} using existing Roles from the database" do
      role_keys = []
      role_keys << "default"
      ActiveRecord::Base.connection.execute("SELECT roles.* FROM roles").to_a.each do |role|
        role_keys << role["key"]
        migrating_role_ids[role["id"]] = role["key"]
      end
      added_roles = []
      if Rails.env.development?
        Role.reload(true)
        existing_roles = Role.all.map(&:id)
        File.open(yml_file_path, "a") do |file|
          role_keys.each do |key|
            unless existing_roles.include?(key)
              added_roles << key
              file.puts("#{key}:")
            end
          end
        end
        if added_roles.any?
          puts "The following roles were automatically added to your config/models/roles.yml file:"
          puts added_roles.to_sentence
          puts "You will need to manually configure the settings for each role.  See instructions in CHANGELOG.md"
        end
      end
    end
    say_with_time "Migrating all existing MembershipRole records to the new role_ids column" do
      Membership.find_each do |membership|
        membership_role_ids = ActiveRecord::Base.connection.execute("SELECT roles.id FROM roles INNER JOIN membership_roles ON roles.id = membership_roles.role_id WHERE membership_roles.membership_id = #{membership.id}").to_a.map { |result| result.dig("id") }
        membership_role_ids.map! { |id| migrating_role_ids[id] }
        membership.update_column(:role_ids, membership_role_ids)
      end
    end
    drop_table :membership_roles
    drop_table :roles
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  def yml_file_path
    "config/models/roles.yml"
  end
end
