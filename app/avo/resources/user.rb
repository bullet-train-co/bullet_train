class Avo::Resources::User < Avo::BaseResource
  self.title = :full_name
  self.includes = []
  self.search = {
    query: -> { query.ransack(id_eq: params[:q], first_name_cont: params[:q], last_name_cont: params[:q], email_cont: params[:q], m: "or").result(distinct: false) },
    item: -> {
      {
        title: record.full_name,
      }
    }
  }

  def fields
    field :id, as: :id
    field :email, as: :text
    field :first_name, as: :text
    field :last_name, as: :text
    field :time_zone, as: :text
    field :current_team, as: :belongs_to

    field :teams, as: :has_many, through: :teams
    field :memberships, as: :has_many
  end
end
