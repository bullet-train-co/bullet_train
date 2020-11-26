module Account::BootstrapHelper
  def first_btn_primary
    # the first time we hit this method, @first will be true.
    # the second time, it'll already be defined and should remain false.
    @first ||= 'first'

    if @first == 'first'
      @first = 'not-first'
      return 'btn-primary'
    else
      return 'btn-link'
    end
  end
end
