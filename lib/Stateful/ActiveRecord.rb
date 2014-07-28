# Stateful/ActiveRecord.rb
# Stateful::ActiveRecord

require_relative '../Stateful'

module Stateful
  module ActiveRecord

    class << self

      def extended(klass)
        klass.extend(Stateful::ClassMethods)
        klass.send(:include, Stateful::InstanceMethods)
        klass.send(:include, Stateful::ActiveRecord::InstanceMethods)
      end
      alias_method :included, :extended

    end # class << self

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
