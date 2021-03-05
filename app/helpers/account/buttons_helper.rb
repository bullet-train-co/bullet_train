module Account::ButtonsHelper
  def first_button_primary(context = nil)
    @global ||= {}

    if !@global[context]
      @global[context] = true
      "button"
    else
      "button-secondary"
    end
  end
end
