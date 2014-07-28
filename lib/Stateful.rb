# Stateful.rb
# Stateful

# 20140111, 27
# 0.5.2

require_relative 'Stateful/ClassMethods'
require_relative 'Stateful/InstanceMethods'

module Stateful

  class << self

    def load_persistance_class_instance_methods(klass)
      if defined?(ActiveRecord::Base) && klass < ActiveRecord::Base
        require_relative "Stateful/ActiveRecord"
        klass.send(:include, Stateful::ActiveRecord::InstanceMethods)
      else
        require_relative "Stateful/Poro"
        klass.send(:include, Stateful::Poro::InstanceMethods)
      end
    end

    def extended(klass)
      klass.extend(Stateful::ClassMethods)
      klass.send(:include, Stateful::InstanceMethods)
      load_persistance_class_instance_methods(klass)
    end
    alias_method :included, :extended

  end # class << self

end
