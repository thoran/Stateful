# Stateful/ActiveRecord/ClassMethods.rb
# Stateful::ActiveRecord::ClassMethods

module Stateful
  module ActiveRecord
    module ClassMethods

      def set_event_method(transition)
        define_method "#{transition.event_name}" do
          next_state = self.class.stateful_states.find(current_state.next_state_name(transition.event_name))
          if self.class.column_names.include?('active')
            if self.class.stateful_states.final_states.include?(next_state)
              self.send('active=', false)
            else # don't assume that active defaults to true and set it anyway...
              self.send('active=', true)
            end
          end
          self.send('current_state=', next_state)
        end
      end

    end
  end
end
