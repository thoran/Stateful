# Stateful/State.rb
# Stateful::State

require 'set'
require_relative 'Transition'

module Stateful
  class State

    attr_accessor :name
    attr_accessor :transitions

    def initialize(name, options = {})
      @name = name
      if options[:non_deterministic] || (options[:deterministic] && !options[:deterministic])
        @transitions = Set.new
      else # if options[:deterministic] || !options[:non_deterministic], or no options set, then
        @transitions = Array.new
      end
    end

    def event(event)
      event_name, new_state = event.keys.first, event.values.first
      transitions << Transition.new(event_name, new_state)
    end
    alias_method :on, :event

    def next_state_name(event_name)
      if matching_transition = transitions.detect{|transition| transition.event_name == event_name}
        matching_transition.next_state_name
      end
    end

  end
end
