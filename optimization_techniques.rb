require 'individual'
require 'monkey'

class OptimizationTechnique
  attr_reader :best_fitness, :best_individual, :current_generation
  
  def initialize(type_module, population_size = 200)
    # Set up the type and call it's init method
    @type_module = type_module
    self.class.class_eval{ include type_module }
    init()
    
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
end

class HillClimber < OptimizationTechnique
  
  def iterate()
    keep = @population_size / 10
    
    sorted = @individuals.sort_by do |individual|
      individual.fitness = fitness(individual)
    end

    @best_individual = sorted.last
    @best_fitness = @best_individual.fitness
    
    next_generation = sorted[0..(keep-1)].map do |individual|
                        individual.deep_copy     # bring the top 10% unaltered
                      end +
                      Array.new(@population_size - keep).fill do |i|
                        mutate(@best_individual) # rest are mutations
                      end
    
    @individuals = next_generation
    @current_generation += 1
  end
end

class GeneticRecombination
end

