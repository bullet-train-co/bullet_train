class Account::TeamsController < Account::ApplicationController
  include Account::Teams::ControllerBase
  before_action -> { paginate_children(children_to_paginate) }, only: [:show]

  private

  def permitted_fields
    [
      :description,
      # 🚅 super scaffolding will insert new fields above this line.
    ]
  end

  def permitted_arrays
    {
      # 🚅 super scaffolding will insert new arrays above this line.
    }
  end

  # We use this method to paginate children in the show view.
  def paginate_children(models)
    models.each do |model|
      set_pagy(model, self)
    end
  end

  def children_to_paginate
    [
      # 🚅 super scaffolding will insert new fields for pagination above this line.
    ]
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
    strong_params
  end
end
