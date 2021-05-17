module Api::V1::Defaults
  extend ActiveSupport::Concern

  included do
    before do
      header["Access-Control-Allow-Origin"] = "*"
      header["Access-Control-Request-Method"] = "*"
    end

    helpers do
      def current_token
        doorkeeper_access_token
      end

      def current_user
        resource_owner
      end

      def current_scopes
        current_token.scopes
      end

      def current_team
        current_user.current_team
      end

      def current_membership
        current_user.memberships.where(team: current_team).first
      end
    end
  end
end
