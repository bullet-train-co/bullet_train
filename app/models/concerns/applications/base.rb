module Applications::Base
  extend ActiveSupport::Concern

  included do
    has_many :teams
    has_many :users

    # There is only ever one application record.
    validates :id, comparison: {equal_to: 1}
  end

  def name
    I18n.t("application.name")
  end

  def label_string
    name
  end

  def team
    nil
  end
end
