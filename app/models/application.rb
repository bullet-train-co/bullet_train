class Application < ApplicationRecord
  # There is only ever one application record.
  validates :id, comparison: { equal_to: 1 }
  def name
    I18n.t("application.name")
  end
  has_many :teams
  has_many :users
  def team
    nil
  end
end
