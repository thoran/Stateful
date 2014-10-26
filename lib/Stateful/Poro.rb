# Stateful/Poro.rb
# Stateful::Poro

require_relative File.join('..', 'Stateful')
require_relative File.join('Poro', 'ClassMethods')
require_relative File.join('Poro', 'InstanceMethods')

module Stateful
  module Poro

    class << self

      def extended(klass)
        klass.extend(Stateful::ClassMethods)
        klass.extend(Stateful::Poro::ClassMethods)
        klass.send(:include, Stateful::InstanceMethods)
        klass.send(:include, Stateful::Poro::InstanceMethods)
      end
      alias_method :included, :extended

    end # class << self

  end
end
