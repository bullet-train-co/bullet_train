module Waiting
  def wait_by_true(condition)
    Timeout.timeout(Capybara.default_max_wait_time) do
      sleep(0.5) if condition
    end
  end
end
