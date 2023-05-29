module SuperSelectHelper
  # Place your options for customing super select elements here.
  # https://select2.org/configuration/options-api
  def super_select_config
    {
      # allowClear: true,
      # dropdownCssClass: "color: blue;"
    }.to_json
  end
end
