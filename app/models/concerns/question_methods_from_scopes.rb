module QuestionMethodsFromScopes
  extend ActiveSupport::Concern

  class_methods do
    def scope(scope_name, body)
      super

      # If a `current` scope is defined on `Membership`, `membership.current?` should be generated automatically.
      # If a `tombstones` scope is defined on `Membership`, `membership.tombstone?` should be generated automatically.
      method_name = "#{scope_name.to_s.singularize}?"
      unless method_defined?(method_name)
        define_method(method_name) do
          unless persisted?
            raise "You can't call scope-generated `?` methods on objects that aren't persisted. Perhaps you need to define `#{self.class.name}##{method_name}` in Ruby?"
          end

          self_scope.send(scope_name).any?
        end
      end
    end
  end

  # Called on an individual record, this method returns an Active Record scope that will only ever return that object.
  # It can be chained together with other scopes and `any?` to determine whether that object exists in those scopes.
  def self_scope
    self.class.where(id: id)
  end
end
