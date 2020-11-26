class Api::V1::UserController < Api::V1::AuthenticatedController
  def user
    render json: {id: current_user.id, email: current_user.email}
  end
end
