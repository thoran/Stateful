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
      stateful_states.initial_state(state_name, options, &block)
    end

    def final_state(*state_names)
      stateful_states.final_state(*state_names)
    end

    def final_states(*state_names)
      stateful_states.final_states(*state_names)
    end

    def state(state_name, options = {}, &block)
      stateful_states.state(state_name, options, &block)
    end

    def stateful(options = {}, &block)
      stateful_states.stateful(options, &block)
    end

    # end DSL

    def set_event_method(transition)
      define_method "#{transition.event_name}" do
        next_state = self.class.stateful_states.find(current_state.next_state_name(transition.event_name))
        self.send('current_state=', next_state)
      end
    end

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
