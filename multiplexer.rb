# 2 input multiplexer experiment

require 'optimization_techniques'

module Multiplexer
  TEST_CASES = []
  
  def init
    2.times do |in0|
      2.times do |in1|
        2.times do |select|
          TEST_CASES.push({
            :in => pack(in0,in1,select),
            :out => select == 0 ? in0 : in1
          })
        end
      end
    end
  end
  
  def fitness(individual, iterations=100)
    correct = 0.0
    iterations.times do
      TEST_CASES.shuffle.each do |t|
        individual.transition(t[:in])
        correct += 1 if individual.output == t[:out]
      end
    end
    correct / (TEST_CASES.size * iterations)
  end

  def pack(in0, in1, select)
    # Place three 1 bit values side-by side in a 3bit number
    (((in0 << 1) + in1) << 1) + select
  end
end

start_time = Time.now
# 2 inputs + control, 1 output
h = Optimization::GeneticRecombinant.new(Multiplexer, 3, 1, 2)
while 1 do
  h.iterate()
  puts "Generation #{h.current_generation} best fitness: #{h.best_fitness}"
  h.best_individual.debug
  break if h.best_fitness >= 1
end
h.best_individual.reset # return to initial state
puts h.best_individual.dump.inspect

end_time = Time.now
puts "Success! in #{end_time-start_time} seconds"
