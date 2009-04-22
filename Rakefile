require 'individual'

entity = 'adder'
inputs = 4
outputs = 4
test_bench = 'adder_tb'

task :default do
  mkdir_p 'build'

  # create the individual
  id = 0
  individual = Individual.new(entity, id, inputs, outputs)
  file = "individual_#{id}.vhdl"
  File.open(File.join('build', file), 'w') do |f|
    f.write(individual.render)
  end

  cd 'build'

  # analyze and elaborate the individual
  sh "ghdl -a #{file}"
  sh "ghdl -e #{entity}"

  # analyze and elaborate the test_bench
  test_bench_path = File.join('..', "#{test_bench}.vhdl")
  sh "ghdl -a #{test_bench_path}"
  sh "ghdl -e #{test_bench}"

  #create input/output files
  inputs.times do |i|
    touch "in#{i-1}.txt"
  end
  touch "out.txt"

  # finally! run the test_bench (and generate a vcd file)
  sh "ghdl -r #{test_bench} --vcd=#{test_bench}.vcd"
end

