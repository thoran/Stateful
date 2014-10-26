# Stateful.rb
# Stateful

# 20141026
# 0.12.0

require_relative File.join('Stateful', 'ClassMethods')
require_relative File.join('Stateful', 'InstanceMethods')

module Stateful

  class << self

    def load_persistence_class_instance_methods(klass)
      if defined?(ActiveRecord::Base) && klass < ActiveRecord::Base
        require_relative File.join('Stateful', 'ActiveRecord')
        klass.extend(Stateful::ActiveRecord::ClassMethods)
        klass.send(:include, Stateful::ActiveRecord::InstanceMethods)
      else
        require_relative File.join('Stateful', 'Poro')
        klass.extend(Stateful::Poro::ClassMethods)
        klass.send(:include, Stateful::Poro::InstanceMethods)
      end
    end

    def extended(klass)
      klass.extend(Stateful::ClassMethods)
      klass.send(:include, Stateful::InstanceMethods)
      load_persistence_class_instance_methods(klass)
    end
    alias_method :included, :extended

  end # class << self

end
