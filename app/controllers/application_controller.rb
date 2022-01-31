class ApplicationController < ActionController::Base
  include Controllers::Base

  protect_from_forgery with: :exception
end
