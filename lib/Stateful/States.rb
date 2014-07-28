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

    def find_or_create(state_name, options = {})
      find(state_name) || (
        state = State.new(state_name, options)
        all << state
        state
      )
    end

    def initial_state(state = nil)
      if state
        state_name, options = (
          if state.is_a?(Array)
            [state.first, state.last]
          else
            [state, {}]
          end
        )
        @initial_state = find_or_create(state_name, options)
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

    def state(state_name, options = {}, &block)
      state = find_or_create(state_name, options)
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
