# Stateful/Poro/InstanceMethods.rb
# Stateful::Poro::InstanceMethods

module Stateful
  module Poro
    module InstanceMethods

      def current_state=(state)
        @current_state = self.class.stateful_states.find(state)
      end

      def current_state
        @current_state ||= self.class.stateful_states.initial_state
      end

    end
  end
end
