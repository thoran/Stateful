# SimpleState.rb
# SimpleState

# 20131228
# 0.0.0

require 'set'

module SimpleState

  def self.included(klass)
    klass.extend(ClassMethods)
    klass.send(:include, InstanceMethods)
  end

  module ClassMethods

    def initial_state(state_name)
      define_method :initial_state do
        State.find_or_create(state_name)
      end
    end

    def state(state_name, &block)
      @state = State.find_or_create(state_name)
      instance_eval(&block) if block
      @state.transitions.each do |transition|
        set_event_method(transition)
        set_status_boolean_method(state_name)
      end
    end
    alias_method :final_state, :state

    def set_event_method(transition)
      module_eval do
        define_method "#{transition.event_name}" do
          instance_variable_set(:@current_state, State.find(current_state.next_state(transition.event_name)))
        end
      end
    end

    def set_status_boolean_method(state_name)
      module_eval do
        define_method "#{state_name}?" do
          current_state.name == state_name
        end
      end
    end

    def event(event)
      @state.event(event)
    end

  end # class ClassMethods

  module InstanceMethods

    def current_state=(state)
      @current_state = State.find(state)
    end

    def current_state
      @current_state ||= State.find(initial_state)
    end

  end # class InstanceMethods

  class State

    @all = []
    @initial_state = nil

    class << self

      attr_accessor :all

      def detect(candidate_state)
        candidate_state_name = candidate_state.is_a?(State) ? candidate_state.name : candidate_state
        all.detect{|state| state.name == candidate_state_name}
      end
      alias_method :find, :detect

      def missing?(state)
        !detect(state)
      end
      alias_method :new_state?, :missing?

      def present?(state)
        !!detect(state)
      end

      def find_or_create(state_name)
        find(state_name) || (state = State.new(state_name); all << state; state)
      end

      def initial_state=(state_name)
        @initial_state = State.new(state_name)
        all << @initial_state
        @initial_state
      end

      def initial_state
        @initial_state
      end

    end # class << self

    attr_accessor :name
    attr_accessor :transitions

    def initialize(name)
      @name = name
      @transitions = Set.new
    end

    def event(event)
      event_name, new_state = event.keys.first, event.values.first
      transitions << Transition.new(event_name, new_state)
    end

    def new_state?
      State.new_state?(self)
    end
  
    def next_state(event_name)
      transitions.detect{|transition| transition.event_name == event_name}.next_state_name
    end

  end # class State

  class Transition

    attr_reader :event_name
    attr_reader :next_state_name

    def initialize(event_name, next_state_name)
      @event_name, @next_state_name = event_name, next_state_name
    end

  end # class Transition

end
