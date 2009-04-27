require 'individual'

home = File.dirname(__FILE__)

entity = 'adder'
inputs = 4          # how many bits of input to in the state machine
logical_inputs = 2  # how many conceptual inputs to the device we're creating
outputs = 4
test_bench = 'adder_tb'
build = 'build'

task :build do
  mkdir_p File.join(entity, build)

  # create the individual
  id = 0
  individual = Individual.new(entity, id, inputs, outputs)
  file = "individual_#{id}.vhdl"
  File.open(File.join(entity, build, file), 'w') do |f|
    f.write(individual.render)
  end

  cd File.join(entity, build)

  # analyze and elaborate the individual
  sh "ghdl -a #{file}"
  sh "ghdl -e #{entity}"

  # analyze and elaborate the test_bench
  test_bench_path = File.join('..', "#{test_bench}.vhdl")
  sh "ghdl -a #{test_bench_path}"
  sh "ghdl -e #{test_bench}"

  #create input/output files
  logical_inputs.times do |i|
    touch "in#{i}.txt"
  end
  touch "out.txt"
end

task :run => :build do
  # finally! run the test_bench (and generate a vcd file)
  sh "ghdl -r #{test_bench} --vcd=#{test_bench}.vcd" do |ok, res|
    # we expect this to have an error, ignore it
  end
end

task :clean do
  rm_rf File.join(entity, build)
end

