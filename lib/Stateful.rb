# Stateful.rb
# Stateful

# 20140111
# 0.4.0

require 'set'

module Stateful

  class << self

    def extended(klass)
      klass.extend(Stateful::ClassMethods)
      klass.send(:include, Stateful::InstanceMethods)
      if defined?(ActiveRecord::Base) && klass < ActiveRecord::Base
        require_relative "Stateful/ActiveRecord"
        klass.send(:include, Stateful::ActiveRecord::InstanceMethods)
      else
        require_relative "Stateful/Poro"
        klass.send(:include, Stateful::Poro::InstanceMethods)
      end
    end
    alias_method :included, :extended

  end # class << self

  module ClassMethods

    def stateful_states
      @stateful_states ||= Stateful::States.new
    end

    def initial_state(state_name)
      stateful_states.initial_state = state_name
    end

    def final_state(state_name)
      stateful_states.final_state = state_name
    end

    def state(state_name, &block)
      @state = stateful_states.find_or_create(state_name)
      instance_eval(&block) if block
      @state.transitions.each do |transition|
        set_event_method(transition)
        set_status_boolean_method(state_name)
      end
    end
    alias_method :given, :state

    def set_event_method(transition)
      module_eval do
        define_method "#{transition.event_name}" do
          self.send('current_state=', self.class.stateful_states.find(current_state.next_state_name(transition.event_name)))
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
    alias_method :on, :event
    alias_method :action, :state
    alias_method :message, :state
    alias_method :trigger, :state

  end # module ClassMethods

  module InstanceMethods

    def next_state_name(event_name)
      current_state.next_state_name(event_name)
    end

    def next_state(event_name)
      self.class.stateful_states.find(current_state.next_state_name(event_name))
    end

    def transitions
      current_state.transitions
    end

    def initial_state?
      self.class.stateful_states.initial_state == current_state
    end

    def final_state?
      self.class.stateful_states.final_state == current_state
    end

  end # module InstanceMethods

  class States

    attr_reader :all
    attr_reader :initial_state
    attr_reader :final_state

    def initialize
      @all = []
      @initial_state = nil
      @final_state = nil
    end

    def detect(candidate_state)
      candidate_state_name = candidate_state.is_a?(State) ? candidate_state.name : candidate_state
      self.all.detect{|state| state.name == candidate_state_name}
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
      find(state_name) || (
        state = State.new(state_name)
        all << state
        state
      )
    end

    def initial_state=(state_name)
      @initial_state = State.new(state_name)
      all << @initial_state
      @initial_state
    end

    def final_state=(state_name)
      @final_state = State.new(state_name)
      all << @final_state
      @final_state
    end

  end # class States

  class State

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

    def next_state_name(event_name)
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
