# Stateful/ClassMethods.rb
# Stateful::ClassMethods

require_relative 'States'

module Stateful
  module ClassMethods

    def stateful_states
      @stateful_states ||= Stateful::States.new
    end

    def initial_state(state_name = nil)
      if state_name
        stateful_states.initial_state = state_name
      else
        stateful_states.initial_state
      end
    end

    def final_state(state_name = nil)
      if state_name
        stateful_states.final_state = state_name
      else
        stateful_states.final_state
      end
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

  end
end
