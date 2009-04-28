require 'individual'

def pack(a, b)
  # Place two 2bit numbers side-by side in a 4bit number
  (a << 2) + b
end

def fitness(individual, iterations=10000)
  correct = 0.0
  iterations.times do |i|
    a, b = rand(4), rand(4)
    individual.transition(pack(a,b))
    expected = a + b
    got = individual.output
    correct += 1 if expected == got
  end
  correct / iterations
end

class HillClimber
  attr_reader :best_fitness, :best_individual, :current_generation

  def initialize(population_size = 20)
    @population_size = population_size
    @current_generation = -1
    @best_fitness = 0
    @best_individual = nil
    
    # 20 random individuals
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
      ind = @best_individual.deep_copy
      ind.mutate unless i == 0 # bring one exact copy to the next generation
      ind
    end
    @individuals = next_generation
    @current_generation += 1
  end
end

h = HillClimber.new(20)
boundary = 0.4
while 1 do
  h.iterate()
  puts "Generation #{h.current_generation} best fitness: #{h.best_fitness}"
  if h.best_fitness >= boundary
    boundary += 0.1
    puts h.best_individual.inspect
  end
end


