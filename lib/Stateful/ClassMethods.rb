# Stateful/ClassMethods.rb
# Stateful::ClassMethods

require_relative 'States'

module Stateful
  module ClassMethods

    def stateful_states
      @stateful_states ||= Stateful::States.new(self)
    end

    # DSL

    def initial_state(state_name = nil, options = {}, &block)
      if state_name
        stateful_states.initial_state = state_name, options
        state(state_name, options, &block) if block
      else
        stateful_states.initial_state
      end
    end

    def final_state(*state_names)
      final_states(*state_names).first
    end

    def final_states(*state_names)
      stateful_states.final_states(*state_names)
    end

    def state(state_name, options = {}, &block)
      state = stateful_states.find_or_create(state_name, options)
      state.instance_eval(&block) if block
      state.transitions.each do |transition|
        set_event_method(transition)
      end
      set_status_boolean_method(state_name)
    end

    def stateful(options = {}, &block)
      stateful_states.stateful(&block) if block
    end

    # end DSL

    def set_status_boolean_method(state_name)
      define_method "#{state_name}?" do
        current_state.name == state_name
      end
    end

    # boolean methods

    def final_state?
      !final_states.empty?
    end
    alias_method :has_final_state?, :final_state?

  end
end
