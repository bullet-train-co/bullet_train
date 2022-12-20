class Admin::ApplicationController < ApplicationController
  include Admin::Controllers::Base

  def current_ability
    @current_ability ||= Admin::Ability.new(current_user)
  end
end
