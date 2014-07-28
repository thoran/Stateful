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

    # It doesn't make much sense to specify any options here, such as those pertaining to whether
    # a transition is deterministic or not, since there are no transitions from a final state.
    def final_state(state_name = nil)
      if state_name
        stateful_states.final_state = state_name
      else
        stateful_states.final_state
      end
    end

    def state(state_name, options = {}, &block)
      state = stateful_states.find_or_create(state_name, options)
      state.instance_eval(&block) if block
      state.transitions.each do |transition|
        set_event_method(transition)
      end
      set_status_boolean_method(state_name)
    end

    def stateful(&block)
      stateful_states.stateful(&block) if block
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
      !final_state.nil?
    end
    alias_method :has_final_state?, :final_state?

  end
end
