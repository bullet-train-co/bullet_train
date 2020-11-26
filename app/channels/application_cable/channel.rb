module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def current_ability
      @current_ability ||= Ability.new(current_user)
    end
  end
end
