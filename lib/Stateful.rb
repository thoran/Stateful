# Stateful.rb
# Stateful

require_relative File.join('Stateful', 'ClassMethods')
require_relative File.join('Stateful', 'InstanceMethods')

module Stateful

  class << self

    def set_column_name(klass)
      if defined?(::ActiveRecord::Base) && klass < ::ActiveRecord::Base
        unless klass.instance_variable_get(:@stateful_column_name)
          klass.instance_variable_set(:@stateful_column_name, 'current_state')
        end
      else
        unless klass.instance_variable_get(:@stateful_variable_name)
          klass.instance_variable_set(:@stateful_variable_name, 'current_state')
        end
      end
    end

    def load_persistence_class_methods(klass)
      if defined?(::ActiveRecord::Base) && klass < ::ActiveRecord::Base
        require_relative File.join('Stateful', 'ActiveRecord')
        klass.extend(Stateful::ActiveRecord::ClassMethods)
      else
        require_relative File.join('Stateful', 'Poro')
        klass.extend(Stateful::Poro::ClassMethods)
      end
    end

    def define_instance_methods(klass)
      if defined?(::ActiveRecord::Base) && klass < ::ActiveRecord::Base
        klass.define_stateful_column_name_setter_method
        klass.define_stateful_column_name_getter_method
      else
        klass.define_stateful_variable_name_setter_method
        klass.define_stateful_variable_name_getter_method
      end
      klass.define_next_state_method
      klass.define_transitions_method
      klass.define_initial_stateQ_method
      klass.define_final_stateQ_method
    end

    def extended(klass)
      klass.extend(Stateful::ClassMethods)
      klass.send(:include, Stateful::InstanceMethods)
      set_column_name(klass)
      load_persistence_class_methods(klass)
      define_instance_methods(klass)
    end
    alias_method :included, :extended

  end # class << self

end
