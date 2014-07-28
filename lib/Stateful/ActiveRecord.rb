# Stateful/ActiveRecord.rb
# Stateful::ActiveRecord

require_relative '../Stateful'
require_relative 'ActiveRecord/InstanceMethods'

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

  end
end
