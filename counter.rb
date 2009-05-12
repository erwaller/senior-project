# 2-bit counter with reset experiment

require 'optimization_techniques'

module Counter
  
  def init
    # do nothing, but define init to prevent method missing error
  end
  
  def fitness(individual, iterations=100)
    correct = 0.0
    i = 0
    iterations.times do
      rst = random_reset
      i = rst == 1 ? 0 : (i+1)%4
      individual.transition(rst)
      correct += 1 if individual.output == i
     #puts "i: #{i}, reset: #{rst}"
    end
    correct / iterations
  end

  def random_reset
    # signal a reset every once in a while
    rand(10) == 0 ? 1 : 0
  end
end

start_time = Time.now
# reset, 2-bits of output
h = Optimization::GeneticAsexual.new(Counter, 1, 2, 4)
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
