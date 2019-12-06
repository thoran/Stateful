# Stateful/InstanceMethods.rb
# Stateful::InstanceMethods

module Stateful
  module InstanceMethods

    def all_states
      self.class.stateful_states
    end

    def initial_state
      self.class.initial_state
    end

    def final_state
      self.class.final_state
    end

    def final_states
      self.class.final_states
    end

    # predicate methods

    def active?
      !final_state?
    end

  end
end
