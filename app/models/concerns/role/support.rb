module Role::Support
  extend ActiveSupport::Concern

  class_methods do
    def roles_only *roles
      @allowed_roles = roles.map(&:to_sym)
    end

    def assignable_roles
      return Role.assignable if @allowed_roles.nil?
      Role.assignable.select { |role| @allowed_roles.include?(role.key.to_sym) }
    end

    # Note default_role is an ActiveRecord core class method so we need to use something else here
    def default_roles
      dr = Role.default
      return [dr] if @allowed_roles.nil?
      @allowed_roles.include?(dr.key.to_sym) ? [dr] : []
    end
  end

  included do
    validate :validate_roles
    # This query will return records that have a role "included" in a different role they have.
    # For example, if you do with_roles(editor) it will return admin users if the admin role inclcudes the editor role
    scope :with_roles, ->(roles) { where("#{table_name}.role_ids ?| array[:keys]", keys: roles.map(&:key_plus_included_by_keys).flatten.uniq.map(&:to_s)) }
    # This query will return roles that include the given role.  See with_roles above for details
    scope :with_role, ->(role) { role.nil? ? all : with_roles([role]) }
    scope :viewers, -> { where("#{table_name}.role_ids = ?", [].to_json) }
    scope :editors, -> { with_role(Role.find_by_key("editor")) }
    scope :admins, -> { with_role(Role.find_by_key("admin")) }

    after_save :invalidate_cache
    after_destroy :invalidate_cache

    def validate_roles
      self.role_ids = role_ids.select { |key| key.present? }
      return if @allowed_roles.nil?
      roles.each do |role|
        errors.add(:roles, :invalid) unless @allowed_roles.include?(role.key.to_sym)
      end
    end

    def roles
      Role::Collection.new(self, (self.class.default_roles + roles_without_defaults).compact.uniq)
    end

    def roles=(roles)
      self.role_ids = roles.map(&:key)
    end

    def assignable_roles
      roles.select(&:assignable?)
    end

    def roles_without_defaults
      role_ids.map { |role_id| Role.find role_id }
    end

    def manageable_roles
      roles.map(&:manageable_roles).flatten.uniq.map { |role_key| Role.find_by_key(role_key) }
    end

    def can_manage_role?(role)
      manageable_roles.include?(role)
    end

    def admin?
      roles.select(&:admin?).any?
    end

    def invalidate_cache
      user&.invalidate_ability_cache
    end
  end
end
