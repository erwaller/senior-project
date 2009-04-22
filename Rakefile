require 'individual'
require 'fileutils'
include FileUtils

entity = 'adder'
inputs = 4
outputs = 4
test_bench = 'adder_tb'

mkdir_p 'build'

# create the individual
id = 0
individual = Individual.new(entity, id, inputs, outputs)
file = File.join('build', "individual_#{id}.vhdl")
File.open(file, 'w') do |f|
  f.write(individual.render)
end

cd 'build'

# analyze and elaborate the individual
system "ghdl -a #{file}"
system "ghdl -e #{entity}"

# analyze and elaborate the test_bench
test_bench_path = File.join('..', "#{test_bench}.vhdl")
system "ghdl -a #{test_bench_path}"
system "ghdl -e #{test_bench}"

#create input/output files
inputs.times do |i|
  touch "in#{i-1}.txt"
end
touch "out.txt"

# finally! run the test_bench (and generate a vcd file)
system "ghdl -r #{test_bench} --vcd=#{test_bench}.vcd"



