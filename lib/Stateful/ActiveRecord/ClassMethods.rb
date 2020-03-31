# Stateful/ActiveRecord/ClassMethods.rb
# Stateful::ActiveRecord::ClassMethods

module Stateful
  module ActiveRecord
    module ClassMethods

      class << self

        def extended(klass)
          klass.define_stateful_column_name_setter_method
          klass.define_stateful_column_name_getter_method
          klass.define_next_state_method
          klass.define_transitions_method
          klass.define_initial_stateQ_method
          klass.define_final_stateQ_method
        end

      end # class << self

      def stateful_column_name=(stateful_column_name)
        @stateful_column_name = stateful_column_name
      end

      def stateful_column_name
        @stateful_column_name
      end

      def define_event_method(transition)
        stateful_column_name = self.instance_variable_get(:@stateful_column_name)
        define_method(transition.event_name) do
          next_state_name = self.send(stateful_column_name).next_state_name(transition.event_name)
          next_state = self.class.stateful_states.find(next_state_name)
          self.send("#{stateful_column_name}=", next_state)
        end
      end

      def define_status_predicate_method(state_name)
        stateful_column_name = self.instance_variable_get(:@stateful_column_name)
        define_method("#{state_name}?") do
          self.send(stateful_column_name).name == state_name
        end
      end

      def define_stateful_column_name_setter_method
        stateful_column_name = self.instance_variable_get(:@stateful_column_name)
        define_method("#{stateful_column_name}=") do |state|
          instance_variable_set("@#{stateful_column_name}", self.class.stateful_states.find(state))
          write_attribute(stateful_column_name, instance_variable_get("@#{stateful_column_name}").name)
          self.save
          instance_variable_get("@#{stateful_column_name}")
        end
      end

      def define_stateful_column_name_getter_method
        stateful_column_name = self.instance_variable_get(:@stateful_column_name)
        define_method(stateful_column_name) do
          instance_variable_set("@#{stateful_column_name}", self.class.stateful_states.find(read_attribute(stateful_column_name)))
          if state = instance_variable_get("@#{stateful_column_name}")
            state
          else
            initial_state = self.class.stateful_states.initial_state
            self.send("#{stateful_column_name}=", initial_state.name)
            initial_state
          end
        end
      end

      def define_next_state_method
        stateful_column_name = self.instance_variable_get(:@stateful_column_name)
        define_method(:next_state) do |event_name|
          next_state_name = self.send(stateful_column_name).next_state_name(event_name)
          all_states.find(next_state_name)
        end
      end

      def define_transitions_method
        stateful_column_name = self.instance_variable_get(:@stateful_column_name)
        define_method(:transitions) do
          self.send(stateful_column_name).transitions
        end
      end

      def define_initial_stateQ_method
        stateful_column_name = self.instance_variable_get(:@stateful_column_name)
        define_method(:initial_state?) do
          self.send(stateful_column_name) == initial_state
        end
      end

      def define_final_stateQ_method
        stateful_column_name = self.instance_variable_get(:@stateful_column_name)
        define_method(:final_state?) do
          final_states.include?(self.send(stateful_column_name))
        end
      end

    end
  end
end
