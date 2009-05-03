# 2-bit adder experiment

require 'optimization_techniques'

module Adder
  TEST_CASES = []
  
  def init()
    4.times do |i|
      4.times do |j|
        TEST_CASES.push({:in => pack(i,j), :out => i+j})
      end
    end
    # add extra instances of the 0 and 6 cases so that
    # each output equiprobable
    TEST_CASES.push({:in => pack(0,0), :out => 0})
    TEST_CASES.push({:in => pack(3,3), :out => 6})
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

  def pack(a, b)
    # Place two 2bit numbers side-by side in a 4bit number
    (a << 2) + b
  end
end

h = GeneticAsexual.new(Adder)
boundary = 0.4
while 1 do
  h.iterate()
  puts "Generation #{h.current_generation} best fitness: #{h.best_fitness}"
  if h.best_fitness >= boundary
    boundary += 0.1
    #puts h.best_individual.inspect
    h.best_individual.debug
  end
  break if h.best_fitness >= 1
end
