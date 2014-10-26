# Stateful/Poro/ClassMethods.rb
# Stateful::Poro::ClassMethods

module Stateful
  module Poro
    module ClassMethods

      def set_event_method(transition)
        define_method "#{transition.event_name}" do
          next_state = self.class.stateful_states.find(current_state.next_state_name(transition.event_name))
          self.send('current_state=', next_state)
        end
      end

    end
  end
end
