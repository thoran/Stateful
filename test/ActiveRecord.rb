# test/ActiveRecord.rb

# 20140616

test_dir = File.dirname(File.expand_path(__FILE__))
active_record_specs = Dir[File.join(test_dir, 'ActiveRecord', '**', '*.rb')]
active_record_specs.each{|spec| require spec}
