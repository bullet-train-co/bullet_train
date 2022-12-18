class Admin::ApplicationsController < Admin::ApplicationController
  include Admin::Applications::ControllerBase

  private

  def permitted_fields
    []
  end

  def permitted_arrays
    {}
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
    strong_params
  end
end
