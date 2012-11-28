$run_all_specs_each_time = false
$run_specs_inline = true

#require 'spec'

def run_specs!(f=nil)
  if $run_specs_inline
    run_specs_drb!(f)
  else
    run_specs_shell!(f)
  end
end

def run_all_specs!(ops={})
  if $run_specs_inline
    run_all_specs_inline!(ops)
  else
    run_specs_shell!(ops)
  end
end


def run_specs_shell!(f=nil)
  require 'pty'
  puts PTY.spawn('bundle exec rake spec')[0].read
end

def run_specs_drb!(f=nil)
  require 'pty'
  f = get_spec_file(f) || "lib/galcon/all_specs.rb"
  #puts "running #{f}"
  
  cmd = "rspec --drb #{f}"
  #puts cmd
  puts PTY.spawn(cmd)[0].read
end

def get_spec_file(f)
  if f && !(f =~ /spec\.rb/i)
    b = File.basename(f).split(".").first
    f = "spec/#{b}_spec.rb"
    if FileTest.exists?(f)
      # nothing
    else
      f = nil
    end
  end
  f
end

def run_specs_inline!(f=nil)
  #return unless f =~ /_spec\.rb/
  orig_f = f
  run_files = lambda do |fs|
    RSpec.instance_eval { @configuration = RSpec::Core::Configuration.new }
    RSpec::world.instance_eval { @example_groups = [] }
    fs.each { |f| load f }
    RSpec::Core::Runner.run([], $stderr, $stdout)
  end

  f = get_spec_file(f)

  if $run_all_specs_each_time
    all = Dir["spec/*_spec.rb"]
    run_files[all] 
  elsif f
    run_files[[f]] 
  end
  
end

def run_all_specs_inline!(ops={})
  return unless ops[:force]
  run_files = lambda do |fs|
    RSpec.instance_eval { @configuration = RSpec::Core::Configuration.new }
    RSpec::world.instance_eval { @example_groups = [] }
    fs.each { |f| load f }
    RSpec::Core::Runner.run([], $stderr, $stdout)
  end
  
  all = Dir["spec/**/*_spec.rb"]

  run_files[all]
end