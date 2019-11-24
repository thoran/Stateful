# Stateful/ActiveRecord.rb
# Stateful::ActiveRecord

require_relative 'ClassMethods'
require_relative 'InstanceMethods'
require_relative File.join('ActiveRecord', 'ClassMethods')   

module Stateful
  module ActiveRecord

    class << self

      def set_column_name(klass)
        unless klass.instance_variable_get(:@stateful_column_name)
          klass.instance_variable_set(:@stateful_column_name, 'current_state')
        end
      end

      def define_instance_methods(klass)
        klass.define_stateful_column_name_setter_method
        klass.define_stateful_column_name_getter_method
        klass.define_next_state_method
        klass.define_transitions_method
        klass.define_initial_stateQ_method
        klass.define_final_stateQ_method
      end

      def extended(klass)
        klass.extend(Stateful::ClassMethods)
        klass.send(:include, Stateful::InstanceMethods)
        set_column_name(klass)
        klass.extend(Stateful::ActiveRecord::ClassMethods)
        define_instance_methods(klass)
      end
      alias_method :included, :extended

    end # class << self

  end
end
