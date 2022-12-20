module Admin::Applications::ControllerBase
  extend ActiveSupport::Concern
  extend Controllers::Base

  included do
    load_and_authorize_resource :application, class: "Application", prepend: true,
      member_actions: (defined?(MEMBER_ACTIONS) ? MEMBER_ACTIONS : []),
      collection_actions: (defined?(COLLECTION_ACTIONS) ? COLLECTION_ACTIONS : [])

    private
  end

  # GET /applications
  # GET /applications.json
  def index
    redirect_to [:admin, Application.first]
  end

  # GET /applications/1
  # GET /applications/1.json
  def show
    @parent_object = Application.first
    @child_object = Application.first
  end

  # GET /applications/1/edit
  def edit
  end

  # PATCH/PUT /applications/1
  # PATCH/PUT /applications/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to [:account, @team], notice: I18n.t("applications.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @team] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def permitted_fields
    raise "It looks like you've removed `permitted_fields` from your controller. This will break Super Scaffolding."
  end

  def permitted_arrays
    raise "It looks like you've removed `permitted_arrays` from your controller. This will break Super Scaffolding."
  end

  def process_params(strong_params)
    raise "It looks like you've removed `process_params` from your controller. This will break Super Scaffolding."
  end
end
