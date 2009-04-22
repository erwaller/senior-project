require 'monkey'

class Individual
  attr_reader :states
  
  def initialize(entity, id, ins, outs, initial_states = 1)
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
    initial_states.times{ add_state }
  end
  
  def mutate()
    add_state           if (states.size < 2 ? p(0.3) : p(0.1))
    remove_state        if p(0.1)
    reorder_states      if p(0.1)
    change_output       if p(0.1)
    replace_transition  if p(0.5)
    reorder_transitions if p(0.1)
  end

  def mutate!()
    self.replace mutate
  end
  
  def render()
    erb :vhdl
  end
private
  # state collection mutations
  def add_state()
    # new state is inserted at a random position
    size = states.size
    pos = rand(size)
    tail = states.slice!(pos, size-pos)
    states.push(new_state(size)).concat(tail)
  end

  def remove_state()
    return unless states.size > 1
    pos = rand(states.size)
    states.slice!(pos)
    states.each{|s| s.ceil(states.size)} #make sure all transitions are valid
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
  def new_state(size = nil)
    size ||= states.size  # needed for add_state
    State.new(@inputs**2, states.size, random_output)
  end

  def random_state()
    pos = rand(states.size)
    states[pos]
  end

  def random_output()
    rand(@outputs**2)
  end

  def p(prob)
    rand() < prob
  end
  
  # code generation
  def erb (view)
    require 'erb'
    template = ERB.new(IO.read("#{view}.erb"))
    template.result(binding).gsub(/^\s+\n/, "")
  end
end

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


