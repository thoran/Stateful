# Stateful/ActiveRecord/InstanceMethods.rb
# Stateful::ActiveRecord::InstanceMethods

module Stateful
  module ActiveRecord
    module InstanceMethods

      def current_state=(state)
        @current_state = self.class.stateful_states.find(state)
        write_attribute(:current_state, @current_state.name)
      end

      def current_state
        @current_state = self.class.stateful_states.find(read_attribute(:current_state))
        @current_state ||= (
          initial_state = self.class.stateful_states.initial_state
          write_attribute(:current_state, initial_state.name)
          initial_state
        )
      end

    end
  end
end
