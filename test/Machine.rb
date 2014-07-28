# 20131228

require '../lib/SimpleState'

class Machine

  include SimpleState

  initial_state :state

  state :state do
    event :an_event => :next_state
    event :another_event => :final_state
  end

  state :next_state do
    event :any_event => :final_state
  end

  final_state :final_state

end

class Machine2

  include SimpleState

  initial_state :state

  state :state do
    event :an_event => :next_state2
    event :another_event => :final_state2
  end

  state :next_state2 do
    event :any_event2 => :final_state2
  end

  final_state :final_state

end

p m = Machine.new
p m.current_state.name
p m.an_event
p m.current_state.name
puts
p m2 = Machine2.new
p m2.current_state.name
p m2.an_event
p m2.current_state.name
