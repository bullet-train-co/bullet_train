class Contact < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :client
  belongs_to :department, optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :client
  has_rich_text :notes
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :first_name, presence: true
  validates :department, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_departments
    team.departments
  end

  # 🚅 add methods above.
end
