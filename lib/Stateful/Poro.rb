# Stateful/Poro.rb
# Stateful::Poro

require_relative '../Stateful'

module Stateful
  module Poro

    class << self

      def extended(klass)
        klass.extend(Stateful::ClassMethods)
        klass.send(:include, Stateful::InstanceMethods)
        klass.send(:include, Stateful::Poro::InstanceMethods)
      end
      alias_method :included, :extended

    end # class << self

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
