class Api::V1::InvitationsController < Api::V1::ApplicationController
  include Api::V1::Invitations::ControllerBase

  private

  def permitted_fields
    [
      # 🚅 super scaffolding will insert new fields above this line.
    ]
  end

  def permitted_arrays
    {
      # 🚅 super scaffolding will insert new arrays above this line.
    }
  end

  def process_params(strong_params)
    strong_params
  end
end
