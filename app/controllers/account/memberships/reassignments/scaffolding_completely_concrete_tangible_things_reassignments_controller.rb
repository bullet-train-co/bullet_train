class Account::Memberships::Reassignments::ScaffoldingCompletelyConcreteTangibleThingsReassignmentsController < Account::ApplicationController
  account_load_and_authorize_resource :scaffolding_completely_concrete_tangible_things_reassignment, through: :membership, through_association: :reassignments_scaffolding_completely_concrete_tangible_things_reassignments

  # GET /account/memberships/:membership_id/reassignments/scaffolding_completely_concrete_tangible_things_reassignments
  # GET /account/memberships/:membership_id/reassignments/scaffolding_completely_concrete_tangible_things_reassignments.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    redirect_to [:account, @membership]
  end

  # GET /account/memberships/reassignments/scaffolding_completely_concrete_tangible_things_reassignments/:id
  # GET /account/memberships/reassignments/scaffolding_completely_concrete_tangible_things_reassignments/:id.json
  def show
  end

  # GET /account/memberships/:membership_id/reassignments/scaffolding_completely_concrete_tangible_things_reassignments/new
  def new
  end

  # GET /account/memberships/reassignments/scaffolding_completely_concrete_tangible_things_reassignments/:id/edit
  def edit
  end

  # POST /account/memberships/:membership_id/reassignments/scaffolding_completely_concrete_tangible_things_reassignments
  # POST /account/memberships/:membership_id/reassignments/scaffolding_completely_concrete_tangible_things_reassignments.json
  def create
    respond_to do |format|
      if @scaffolding_completely_concrete_tangible_things_reassignment.save
        format.html { redirect_to [:account, @membership, :reassignments_scaffolding_completely_concrete_tangible_things_reassignments], notice: I18n.t('memberships/reassignments/scaffolding_completely_concrete_tangible_things_reassignments.notifications.created') }
        format.json { render :show, status: :created, location: [:account, @scaffolding_completely_concrete_tangible_things_reassignment] }
      else
        raise @scaffolding_completely_concrete_tangible_things_reassignment.inspect
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @scaffolding_completely_concrete_tangible_things_reassignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/memberships/reassignments/scaffolding_completely_concrete_tangible_things_reassignments/:id
  # PATCH/PUT /account/memberships/reassignments/scaffolding_completely_concrete_tangible_things_reassignments/:id.json
  def update
    respond_to do |format|
      if @scaffolding_completely_concrete_tangible_things_reassignment.update(scaffolding_completely_concrete_tangible_things_reassignment_params)
        format.html { redirect_to [:account, @scaffolding_completely_concrete_tangible_things_reassignment], notice: I18n.t('memberships/reassignments/scaffolding_completely_concrete_tangible_things_reassignments.notifications.updated') }
        format.json { render :show, status: :ok, location: [:account, @scaffolding_completely_concrete_tangible_things_reassignment] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @scaffolding_completely_concrete_tangible_things_reassignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/memberships/reassignments/scaffolding_completely_concrete_tangible_things_reassignments/:id
  # DELETE /account/memberships/reassignments/scaffolding_completely_concrete_tangible_things_reassignments/:id.json
  def destroy
    @scaffolding_completely_concrete_tangible_things_reassignment.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @membership, :reassignments_scaffolding_completely_concrete_tangible_things_reassignments], notice: I18n.t('memberships/reassignments/scaffolding_completely_concrete_tangible_things_reassignments.notifications.destroyed') }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def scaffolding_completely_concrete_tangible_things_reassignment_params
      strong_params = params.require(:memberships_reassignments_scaffolding_completely_concrete_tangible_things_reassignment).permit(
        # 🚅 super scaffolding will insert new fields above this line.
        # 🚅 super scaffolding will insert new arrays above this line.
        membership_ids: [],
      )

      strong_params[:membership_ids] = create_models_if_new(strong_params[:membership_ids]) do |email|
        # stub out a new membership and invitation with no special permissions.
        membership = current_team.memberships.create(user_email: email, added_by: current_membership)
        invitation = current_team.invitations.create(email: email, from_membership: current_membership, membership: membership)
        membership
      end

      # 🚅 super scaffolding will insert processing for new fields above this line.

      strong_params
    end
end
