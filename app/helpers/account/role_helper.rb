module Account::RoleHelper
  def role_options_for(object)
    object.class.assignable_roles.map { |role| [role.id, t("#{object.class.to_s.pluralize.underscore}.fields.role_ids.options.#{role.key}.label")] }
  end
end
