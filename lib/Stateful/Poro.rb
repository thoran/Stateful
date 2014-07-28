# Stateful/Poro.rb
# Stateful::Poro

require_relative '../Stateful'
require_relative 'Poro/InstanceMethods'

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

  end
end
