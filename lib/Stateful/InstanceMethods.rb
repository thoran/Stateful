# Stateful/InstanceMethods.rb
# Stateful::InstanceMethods

module Stateful
  module InstanceMethods

    def next_state_name(event_name)
      current_state.next_state_name(event_name)
    end

    def all_states
      self.class.stateful_states
    end

    def next_state(event_name)
      all_states.find(current_state.next_state_name(event_name))
    end

    def transitions
      current_state.transitions
    end

    def initial_state?
      self.class.initial_state == current_state
    end

    def final_state?
      self.class.final_state == current_state
    end

    def active?
      !final_state?
    end

  end
end
