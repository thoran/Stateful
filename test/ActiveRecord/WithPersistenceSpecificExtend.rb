# test/ActiveRecord/WithPersistenceSpecificExtend.rb

# 20140616

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'active_record'
require 'pg'
require 'Stateful/ActiveRecord'

class CreateTableMachines < ActiveRecord::Migration

  def change
    create_table :active_record_machine2s do |t|
      t.string :current_state
    end
  end

end

class ActiveRecordMachine2 < ActiveRecord::Base

  extend Stateful::ActiveRecord

  initial_state :initial_state

  state :initial_state do
    on :an_event => :next_state
    on :another_event => :final_state
  end

  state :next_state do
    on :yet_another_event => :final_state
  end

  final_state :final_state

end

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  database: 'test'
)
unless ActiveRecord::Base.connection.tables.include?('active_record_machine2s')
  CreateTableMachines.new.change
end
if ActiveRecord::Base.connection.tables.include?('active_record_machine1s')
  ActiveRecordMachine2.delete_all
end

describe Stateful::ActiveRecord do

  let(:machine){ActiveRecordMachine2.create}

  it "must have an initial state" do
    machine.initial_state.wont_be_nil
  end

  it "must have a final state (if one has been specified)" do
    if ActiveRecordMachine2.final_state?
      machine.final_state.wont_be_nil
    end
  end

  context "initial_state" do
    it "must have an initial state before any events occur" do
      machine.initial_state?.must_equal true
    end

    it "must have an initial state consistent with what is given" do
      machine.initial_state.must_equal ActiveRecordMachine2.stateful_states.initial_state
    end

    it "must have an initial state with name as per the name given" do
      machine.initial_state.name.must_equal :initial_state
    end

    it "must not be in the final state (assuming that initial and final are different states)" do
      machine.final_state?.must_equal false
    end

    it "must know what it's next state is given an event name" do
      machine.next_state(:an_event).must_equal ActiveRecordMachine2.stateful_states.find(:next_state)
      machine.next_state(:another_event).must_equal ActiveRecordMachine2.stateful_states.find(:final_state)
    end

    it "must have an intial state which has as set of transitions to other states" do
      machine.transitions.class.must_equal Array
    end

    it "must have two transitions to other states" do
      machine.transitions.size.must_equal 2
    end

    it "must know what transitions are available" do
      machine.transitions.collect{|t| [t.event_name, t.next_state_name]}.must_equal [[:an_event, :next_state], [:another_event, :final_state]]
    end

    it "must be active" do
      machine.active?.must_equal true
    end
  end

  context "next_state" do
    before do
      machine.an_event
    end

    it "must not be in the initial state" do
      machine.initial_state?.must_equal false
    end

    it "must not be in the final state" do
      machine.final_state?.must_equal false
    end

    it "must be in the next_state state" do
      machine.current_state.name.must_equal :next_state
      machine.next_state?.must_equal true
    end

    it "must have a set of transitions to other states" do
      machine.transitions.class.must_equal Array
    end

    it "must have one transition to other states" do
      machine.transitions.size.must_equal 1
    end

    it "must know what transitions are available" do
      machine.transitions.collect{|t| [t.event_name, t.next_state_name]}.must_equal [[:yet_another_event, :final_state]]
    end

    it "must be active" do
      machine.active?.must_equal true
    end
  end

  context "final_state" do
    before do
      machine.another_event
    end

    it "must have a final state" do
      machine.final_state?.must_equal true
    end

    it "must have a final state consistent with what is given" do
      machine.final_state.must_equal ActiveRecordMachine2.stateful_states.final_state
    end

    it "must have a state with name as per the name given" do
      machine.current_state.name.must_equal :final_state
    end

    it "must not be in the initial state (assuming that initial and final are different states)" do
      machine.initial_state?.must_equal false
    end

    it "must have no transitions" do
      machine.transitions.empty?.must_equal true
    end

    it "must not be active" do
      machine.active?.must_equal false
    end
  end

end
