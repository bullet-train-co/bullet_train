module Roles::Permit
  def permit user, through:, parent:, debug: false
    # Without this, you need to restart the server each time you make changes to the config/models/role.yml file
    Role.reload(true) if Rails.env.development?
    # When changing permissions during development, you may also want to do this on each request:
    # User.update_all ability_cache: nil if Rails.env.development?

    output = []
    added_roles = Set.new

    user.send(through).map(&:roles).flatten.uniq.each do |role|
      unless added_roles.include?(role)
        output << "########### ROLE: #{role.key}"
        output += add_abilities_for(role, user, through, parent)
        added_roles << role
      end
      role.included_roles.each do |included_role|
        unless added_roles.include?(included_role)
          output << "############# INCLUDED ROLE: #{included_role.key}"
          output += add_abilities_for(included_role, user, through, parent)
        end
      end
    end
    if debug
      puts "###########################"
      puts "Auto generated `ability.rb` content:"
      puts output
      puts "############################"
    end
  end

  def add_abilities_for(role, user, through, parent)
    output = []
    role.ability_generator(user, through, parent) do |ag|
      if ag.valid?
        output << "can #{ag.actions}, #{ag.model}, #{ag.condition}"
        can ag.actions, ag.model, ag.condition
      else
        output << "# #{ag.model} does not respond to #{parent} so we're not going to add an ability for the #{through} context"
      end
    end
    output
  end
end
