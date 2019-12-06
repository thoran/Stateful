# Stateful/ClassMethods.rb
# Stateful::ClassMethods

require_relative 'States'

module Stateful
  module ClassMethods

    def stateful_states
      @stateful_states ||= Stateful::States.new(self)
    end

    # start DSL

    def initial_state(state_name = nil, options = {}, &block)
      stateful_states.initial_state(state_name, options, &block)
    end

    def final_state(*state_names)
      stateful_states.final_state(*state_names)
    end

    def final_states(*state_names)
      stateful_states.final_states(*state_names)
    end

    # end DSL

    # predicate methods

    def final_state?
      !final_states.empty?
    end
    alias_method :has_final_state?, :final_state?

  end
end
