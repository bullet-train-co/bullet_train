module Account::ButtonsHelper
  def first_button_primary(context = nil)
    @global ||= {}

    if !@global[context]
      @global[context] = true
      return 'button'
    else
      return 'button-secondary'
    end
  end
end
