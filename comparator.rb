# 4-bit comparator experiment
# 
#  in0 -> |      | -> in0 < in1
#         | comp | -> in0 == in1
#  in1 -> |      | -> in0 > in1
#

require 'optimization_techniques'

module Comparator
  TEST_CASES = []
  
  def init
    4.times do |in0|
      4.times do |in1|
        TEST_CASES.push({
          :in => pack(in0,in1),
          :out => case in0 <=> in1
                  when -1
                    4 # 100
                  when 0
                    2 # 010
                  when 1
                    1 # 001
                  end
        })
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

  def pack(in0, in1)
    # Place two 2-bit values side-by side in a 4-bit number
    (in0 << 2) + in1
  end
end

start_time = Time.now
# two 2-bit inputs, three 1-bit outputs
h = Optimization::GeneticRecombinant.new(Comparator, 4, 3, 3)
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
