require 'individual'
require 'monkey'

def pack(a, b)
  # Place two 2bit numbers side-by side in a 4bit number
  (a << 2) + b
end

@@test_cases = []
4.times do |i|
  4.times do |j|
    @@test_cases.push({:in => pack(i,j), :out => i+j})
  end
end

def fitness(individual, iterations=500)
  correct = 0.0
  iterations.times do
    @@test_cases.shuffle.each do |t|
      individual.transition(t[:in])
      correct += 1 if individual.output == t[:out]
    end
  end
  correct / (@@test_cases.size * iterations)
end

class HillClimber
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
  end

  def iterate()
    best_fit = 0
    best_ind = nil
    @individuals.each do |individual|
       fit = fitness(individual)
       if fit > best_fit
         best_fit = fit
         best_ind = individual
       end
    end

    @best_fitness = best_fit
    @best_individual = best_ind
    
    next_generation = Array.new(@population_size).fill do |i|
      # bring one exact copy to the next generation
      if i == 0
        @best_individual.deep_copy
      else
        mutate(@best_individual)
      end
    end
    @individuals = next_generation
    @current_generation += 1
  end
end

h = HillClimber.new
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


