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

class GeneticAsexual < OptimizationTechnique
  
  def iterate()
    sorted = @individuals.sort_by do |individual|
      individual.fitness = fitness(individual)
    end

    @best_individual = sorted.last
    @best_fitness = @best_individual.fitness
    
    # I think this is steady-state selection
    # hopefully this will allow for more diversity to survive
    top_ten = sorted[-10..-1]
    next_generation = top_ten.map do |individual|
                        individual.deep_copy # top ten carried directly
                      end +
                      Array.new(@population_size-10).fill do |i|
                        mutate(@best_individual) # rest are mutations of the best one
                      end
    
    @individuals = next_generation
    @current_generation += 1
  end
end

class GeneticRecombination
end

