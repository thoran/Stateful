# Stateful/States.rb
# Stateful::States

require_relative 'State'

module Stateful
  class States

    attr_reader :all

    def initialize(klass)
      @klass = klass
      @all = []
      @initial_state = nil
      @final_state = nil
    end

    def detect(candidate_state)
      candidate_state_name = (
        if candidate_state.is_a?(State)
          candidate_state.name
        else
          candidate_state && candidate_state.to_sym
        end
      )
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

    def initial_state(state_name = nil)
      if state_name
        @initial_state = State.new(state_name)
        all << @initial_state
        @initial_state
      else
        @initial_state
      end
    end
    alias_method :initial_state=, :initial_state

    def final_state(state_name = nil)
      if state_name
        @final_state = State.new(state_name)
        all << @final_state
        @final_state
      else
        @final_state
      end
    end
    alias_method :final_state=, :final_state

    def state(state_name, &block)
      state = find_or_create(state_name)
      state.instance_eval(&block) if block
      state.transitions.each do |transition|
        @klass.set_event_method(transition)
      end
      @klass.set_status_boolean_method(state_name)
    end

    def stateful(&block)
      instance_eval(&block) if block
    end

  end
end
