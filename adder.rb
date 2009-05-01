require 'individual'
require 'monkey'

  
class StochasticOptimization
  attr_reader :best_fitness, :best_individual, :current_generation
  
  def initialize(population_size = 20)
    @population_size = population_size
    @current_generation = -1
    @best_fitness = 0
    @best_individual = nil
  
    # Random initial population
    @individuals = Array.new(@population_size).fill do |i|
      # 2-bit adder (no carry-in or carry-out)
      # 4 bits of input, 3 bits of output
      # we want 7 distinct outputs, so give it 7 initial states
      Individual.new('adder', i, 4, 3, 7)
    end
    
    # Call the included module's init function
    init()
  end
end
  

class HillClimber < StochasticOptimization
  
  def iterate()
    sorted = @individuals.sort_by do |individual|
      individual.fitness = fitness(individual)
    end

    @best_individual = sorted.last
    @best_fitness = @best_individual.fitness
  
    next_generation = Array.new(@population_size - 1).fill do |i|
      mutate(@best_individual)
    end.push(@best_individual.deep_copy) # bring a direct copy of the best individual
    
    @individuals = next_generation
    @current_generation += 1
  end
end

module Adder
  TEST_CASES = []
  
  def init()
    4.times do |i|
      4.times do |j|
        TEST_CASES.push({:in => pack(i,j), :out => i+j})
      end
    end
  end
  
  def fitness(individual, iterations=500)
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


class HillClimber
  include Adder
end

h = HillClimber.new()
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
