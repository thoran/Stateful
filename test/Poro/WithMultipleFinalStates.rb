# test/Poro/WithMultipleFinalStates.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Stateful'

class PoroMachine8

  extend Stateful

  initial_state :initial_state do
    on :an_event => :next_state
    on :another_event => :final_state0
  end

  state :next_state do
    on :yet_another_event => :final_state1
  end

  final_state :final_state0, :final_state1

end

describe Stateful::Poro do

  let(:machine){PoroMachine8.new}

  it "must have an initial state" do
    _(machine.initial_state).wont_be_nil
  end

  it "must have a final state (if one has been specified)" do
    if PoroMachine8.final_state?
      _(machine.final_state).wont_be_nil
    end
  end

  context "initial_state" do
    it "must have an initial state before any events occur" do
      _(machine.initial_state?).must_equal true
    end

    it "must have an initial state consistent with what is given" do
      _(machine.initial_state).must_equal PoroMachine8.stateful_states.initial_state
    end

    it "must have an initial state with name as per the name given" do
      _(machine.initial_state.name).must_equal :initial_state
    end

    it "must not be in the final state (assuming that initial and final are different states)" do
      _(machine.final_state?).must_equal false
    end

    it "must know what it's next state is given an event name" do
      _(machine.next_state(:an_event)).must_equal PoroMachine8.stateful_states.find(:next_state)
      _(machine.next_state(:another_event)).must_equal PoroMachine8.stateful_states.find(:final_state0)
    end

    it "must have an intial state which has as set of transitions to other states" do
      _(machine.transitions.class).must_equal Array
    end

    it "must have two transitions to other states" do
      _(machine.transitions.size).must_equal 2
    end

    it "must know what transitions are available and in what order they are presented" do
      _(machine.transitions.collect{|t| [t.event_name, t.next_state_name]}).must_equal [[:an_event, :next_state], [:another_event, :final_state0]]
    end

    it "must be active" do
      _(machine.active?).must_equal true
    end
  end

  context "next_state" do
    before do
      machine.an_event
    end

    it "must not be in the initial state" do
      _(machine.initial_state?).must_equal false
    end

    it "must not be in a final state" do
      _(machine.final_state?).must_equal false
    end

    it "must be in the next_state state" do
      _(machine.current_state.name).must_equal :next_state
      _(machine.next_state?).must_equal true
    end

    it "must have a set of transitions to other states" do
      _(machine.transitions.class).must_equal Array
    end

    it "must have one transition to other states" do
      _(machine.transitions.size).must_equal 1
    end

    it "must know what transitions are available" do
      _(machine.transitions.collect{|t| [t.event_name, t.next_state_name]}).must_equal [[:yet_another_event, :final_state1]]
    end

    it "must be active" do
      _(machine.active?).must_equal true
    end
  end

  context "final_state0" do
    before do
      machine.another_event
    end

    it "must have a final state" do
      _(machine.final_state?).must_equal true
    end

    it "must have a final state consistent with what is given" do
      _(PoroMachine8.stateful_states.final_states).must_include machine.final_state
    end

    it "must have a state with name as per the name given" do
      _(machine.current_state.name).must_equal :final_state0
    end

    it "must not be in the initial state (assuming that initial and final are different states)" do
      _(machine.initial_state?).must_equal false
    end

    it "must have no transitions" do
      _(machine.transitions.empty?).must_equal true
    end

    it "must not be active" do
      _(machine.active?).must_equal false
    end
  end

  context "final_state1" do
    before do
      machine.an_event
      machine.yet_another_event
    end

    it "must have a final state" do
      _(machine.final_state?).must_equal true
    end

    it "must have a final state consistent with what is given" do
      _(PoroMachine8.stateful_states.final_states).must_include machine.final_state
    end

    it "must have a state with name as per the name given" do
      _(machine.current_state.name).must_equal :final_state1
    end

    it "must not be in the initial state (assuming that initial and final are different states)" do
      _(machine.initial_state?).must_equal false
    end

    it "must have no transitions" do
      _(machine.transitions.empty?).must_equal true
    end

    it "must not be active" do
      _(machine.active?).must_equal false
    end
  end

end
