module DeviseCurrentAttributes
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user
  end

  def set_current_user
    if current_user
      Current.user = current_user
    end
  end
end
