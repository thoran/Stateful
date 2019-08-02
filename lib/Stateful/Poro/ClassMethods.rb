# Stateful/Poro/ClassMethods.rb
# Stateful::Poro::ClassMethods

module Stateful
  module Poro
    module ClassMethods

      def stateful_variable_name=(stateful_variable_name)
        @stateful_variable_name = stateful_variable_name
      end

      def stateful_variable_name
        @stateful_variable_name
      end

      def define_event_method(transition)
        stateful_variable_name = self.instance_variable_get(:@stateful_variable_name)
        define_method(transition.event_name) do
          next_state_name = self.send(stateful_variable_name).next_state_name(transition.event_name)
          next_state = self.class.stateful_states.find(next_state_name)
          self.send("#{stateful_variable_name}=", next_state)
        end
      end

      def define_status_boolean_method(state_name)
        stateful_variable_name = self.instance_variable_get(:@stateful_variable_name)
        define_method("#{state_name}?") do
          self.send(stateful_variable_name).name == state_name
        end
      end

      def define_stateful_variable_name_setter_method
        stateful_variable_name = self.instance_variable_get(:@stateful_variable_name)
        define_method("#{stateful_variable_name}=") do |state|
          instance_variable_set("@#{stateful_variable_name}", self.class.stateful_states.find(state))
        end
      end

      def define_stateful_variable_name_getter_method
        stateful_variable_name = self.instance_variable_get(:@stateful_variable_name)
        define_method(stateful_variable_name) do
          if state = instance_variable_get("@#{stateful_variable_name}")
            state
          else
            initial_state = self.class.stateful_states.initial_state
            self.send("#{stateful_variable_name}=", initial_state.name)
            initial_state
          end
        end
      end

      def define_next_state_method
        stateful_variable_name = self.instance_variable_get(:@stateful_variable_name)
        define_method(:next_state) do |event_name|
          next_state_name = self.send(stateful_variable_name).next_state_name(event_name)
          all_states.find(next_state_name)
        end
      end

      def define_transitions_method
        stateful_variable_name = self.instance_variable_get(:@stateful_variable_name)
        define_method(:transitions) do
          self.send(stateful_variable_name).transitions
        end
      end

      def define_initial_stateQ_method
        stateful_variable_name = self.instance_variable_get(:@stateful_variable_name)
        define_method(:initial_state?) do
          self.send(stateful_variable_name) == initial_state
        end
      end

      def define_final_stateQ_method
        stateful_variable_name = self.instance_variable_get(:@stateful_variable_name)
        define_method(:final_state?) do
          final_states.include?(self.send(stateful_variable_name))
        end
      end

    end
  end
end
