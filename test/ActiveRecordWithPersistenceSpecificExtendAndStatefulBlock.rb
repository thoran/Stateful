require 'active_record'
require '../lib/Stateful/ActiveRecord'
require 'pg'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  database: 'test'
)

class CreateMachine < ActiveRecord::Migration

  def change
    create_table :machines do |t|
      t.string :current_state
    end
  end

end

unless ActiveRecord::Base.connection.tables.include?('machines')
  CreateMachine.new.change
end

class Machine < ActiveRecord::Base

  extend Stateful::ActiveRecord

  stateful do
    initial_state :state

    state :state do
      on :an_event => :next_state
      on :another_event => :final_state
    end

    state :next_state do
      on :any_event => :final_state
    end

    final_state :final_state
  end

end

m = Machine.new
p m.initial_state?
p m.final_state?
20.times{print '-'}; puts
p m.current_state.name
p m.transitions
p m.next_state(:an_event)
20.times{print '-'}; puts
p m.an_event
p m.current_state.name
p m.transitions
p m.next_state(:any_event)
20.times{print '-'}; puts
p m.any_event
p m.current_state.name
p m.transitions
20.times{print '-'}; puts
p m.initial_state?
p m.final_state?
