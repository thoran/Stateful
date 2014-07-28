# Stateful/States.rb
# Stateful::States

require_relative 'State'

module Stateful
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

  end
end
