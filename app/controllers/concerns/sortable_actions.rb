module SortableActions
  extend ActiveSupport::Concern

  def reorder
    params[:ids_in_order].each_with_index do |id, sort_order|
      if (child_object = @parent_object.send(@child_collection).find_by_id(id))
        child_object.sort_order = sort_order
        child_object.save
      end
    end
    render json: true, status: :ok
  end
end
