# Stateful/State.rb
# Stateful::State

require 'set'
require_relative 'Transition'

module Stateful
  class State

    attr_accessor :name
    attr_accessor :transitions

    def initialize(name)
      @name = name
      @transitions = Set.new
    end

    def event(event)
      event_name, new_state = event.keys.first, event.values.first
      transitions << Transition.new(event_name, new_state)
    end
    alias_method :on, :event

    def next_state_name(event_name)
      transitions.detect{|transition| transition.event_name == event_name}.next_state_name
    end

  end
end
