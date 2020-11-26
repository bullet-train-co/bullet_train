module DemoHelper
  def demo
    ENV['DEMO'] ? " <small>Demo</small>".html_safe : ""
  end
end
