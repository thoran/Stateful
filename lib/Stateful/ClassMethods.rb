# Stateful/ClassMethods.rb
# Stateful::ClassMethods

require_relative 'States'

module Stateful
  module ClassMethods

    def stateful_states
      @stateful_states ||= Stateful::States.new(self)
    end

    # DSL

    def initial_state(state_name = nil, &block)
      if state_name
        stateful_states.initial_state = state_name
        if block_given?
          state(state_name, &block)
        end
      else
        stateful_states.initial_state
      end
    end

    def final_state(state_name = nil)
      if state_name
        stateful_states.final_state = state_name
      else
        stateful_states.final_state
      end
    end

    def state(state_name, &block)
      state = stateful_states.find_or_create(state_name)
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
        self.send('current_state=', self.class.stateful_states.find(current_state.next_state_name(transition.event_name)))
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

  end
end
