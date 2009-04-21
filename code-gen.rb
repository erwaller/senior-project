require 'monkey'

class State
  attr_accessor :transitions, :output
  
  def initialize(size, number_of_states, output = 0)
    @transitions = Array.new(size).fill{|i| state_or_nil(number_of_states+1)}
    @output = output
  end

  def initialize_copy(from)
    @transitions, @output = from.transitions.clone, from.output
  end

  def reorder_transitions
    @transitions.shuffle!
  end

  def ceil(max)
    # assures all transitions are to valid states
    # transitions will be 0 -> (height-1)
    @transitions.map!{|t| t % max unless t.nil?}
  end

  # transition mutations
  def replace_transition(max)
    # semantics similar to rand (max-1 is highest transition)
    pos = rand(@transitions.size)
    @transitions[pos] = state_or_nil(max)
  end

  def reorder_transitions()
    @transitions.shuffle!
  end
private
  def state_or_nil(max)
    # returns an integer i or nil where
    # 0 <= i < max and P(i) == P(nil)
    r = rand(max*2)
    r > max-1 ? nil : r
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
    @states = []
    add_state
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
  # state collection mutations
  def add_state()
    # new states are appended--instead of inserted
    # at a random position--for now
    states.push(new_state)
  end

  def remove_state()
    return unless states.size > 1
    pos = rand(states.size)
    states.slice!(pos)
    states.each{|s| s.ceil(states.size)} #make sure all transitions are valid
  end

  def replace_state()
    random_state.replace(new_state)
  end

  def reorder_states()
    states.shuffle!
  end

  def change_output()
    random_state.output = random_output
  end
  
  # transition mutations
  def replace_transition()
    random_state.replace_transition(states.size)
  end
  
  def reorder_transitions()
    random_state.reorder_transitions 
  end
  
  # convenience
  def new_state()
    State.new(@inputs**2, states.size, random_output)
  end

  def random_state()
    pos = rand(states.size)
    states[pos]
  end

  def random_output()
    rand(@outputs**2)
  end
  
  # code generation
  def erb (view)
    require 'erb'
    template = ERB.new(IO.read("#{view}.erb"))
    template.result(binding).gsub(/^\s+\n/, "")
  end
end

print Individual.new("adder", 1, 4, 4).render()

