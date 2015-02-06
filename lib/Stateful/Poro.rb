# Stateful/Poro.rb
# Stateful::Poro

require_relative File.join('..', 'Stateful')
require_relative File.join('Poro', 'ClassMethods')

module Stateful
  module Poro

    class << self

      def set_variable_name(klass)
        unless klass.instance_variable_get(:@stateful_variable_name)
          klass.instance_variable_set(:@stateful_variable_name, 'current_state')
        end
      end

      def define_instance_methods(klass)
        klass.define_stateful_variable_name_setter_method
        klass.define_stateful_variable_name_getter_method
        klass.define_next_state_method
        klass.define_transitions_method
        klass.define_initial_stateQ_method
        klass.define_final_stateQ_method
      end

      def extended(klass)
        klass.extend(Stateful::ClassMethods)
        klass.send(:include, Stateful::InstanceMethods)
        set_variable_name(klass)
        klass.extend(Stateful::Poro::ClassMethods)
        define_instance_methods(klass)
      end
      alias_method :included, :extended

    end # class << self

  end
end
