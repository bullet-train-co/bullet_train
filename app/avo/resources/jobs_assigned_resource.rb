class Avo::Resources::JobsAssignedResource < Avo::BaseResource
  self.includes = []
  self.model_class = ::Jobs::AssignedResource
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :job, as: :belongs_to
    field :resource, as: :belongs_to
  end
end
