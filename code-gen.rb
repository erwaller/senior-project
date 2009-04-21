require 'monkey'

class State
  attr_accessor :transitions, :output
  
  def initialize(size = 0, output = 0)
    @transitions = Array.new(size).fill(nil)
    @output = output
  end

  def initialize_copy(from)
    @transitions, @output = from.transitions.clone, from.output
  end

  def reorder_transitions
    @transitions.shuffle!
  end

  def ceil(height)
    # assures all transitions are to valid states
    # transitions will be 0 -> (height-1)
    @transitions.map!{|t| t % height unless t.nil?}
  end
end

class Individual
  attr_reader :states
  
  def initialize(entity, id, ins, outs)
    @id = id
    @entity = entity
    @architecture = "individual_#{@id}"

    # to keep this code simple there is a single unsigned
    # input array. if you want to do something like add
    # two 2-bit integers just put them side-by-side into
    # a 4-bit array
    @inputs = ins
    @outputs = outs

    # a state has an array of transitions, and an output.
    # integer entries in the transition table represent
    # next states, and nil entries represent no transition
    # 
    # here's a sample state machine with 2 inputs, 1 output
    # and 2 states.
    #
    # inputs =>  00   01   10   11   | output 
    # s0     => [nil,   0, nil,   1] |   0
    # s1     => [1  , nil,   0,   0] |   1
    @states = [State.new(@inputs**2)]
  end
  
  def mutate()
  end

  def mutate!()
    self.replace mutate
  end
  
  def render()
    erb :individual
  end
private
  # available mutations
  def add_state()
  end

  def remove_state()
  end

  def replace_state()
    
  end

  def reorder_states()
    @states.shuffle!
  end
  
  # code generation
  def erb (view)
    require 'erb'
    template = ERB.new(IO.read("#{view}.erb"))
    template.result(binding).gsub(/^\s+\n/, "")
  end
end

print Individual.new("adder", 1, 4, 4).render()

