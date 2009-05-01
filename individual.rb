require 'monkey'

class Individual
  attr_reader :states, :id, :entity, :architecture, :inputs, :outputs, :present_state
  attr_accessor :present_state, :fitness
  
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
    initial_states.times{ add_state(initial_states) }

    # code to support state machine simulation
    reset
  end

  def deep_copy()
    # both individual and state are made up of 'simple' types
    # so this works safely
    copy = Marshal.load(Marshal.dump(self))
    copy.reset
    copy
  end
  
  def reset()
    # s0 is always the initial state
    @present_state = 0
    @fitness = nil
  end

  def transition(input)
    next_state = states[present_state].transitions[input]
    @present_state = next_state unless next_state.nil?
    present_state
  end

  def output()
    states[present_state].output
  end
  
  def debug()
    states.each_with_index do |s, i|
      printf("%3d: ", i)
      s.transitions.each do |t|
        printf("%3s ", t)
      end
      printf("| %3d\n", s.output)
    end
  end
  
  def render()
    erb :vhdl
  end

  # state collection mutations
  def add_state(total_states = nil)
    size = states.size
    total_states ||= size # otherwise s0 will always be initialized
                          # with transitions only to itself, and s1 only
                          # to s0 and s1, etc.
    # new state is inserted at a random position
    pos = rand(size)
    tail = states.slice!(pos, size-pos)
    states.push(new_state(total_states)).concat(tail)
  end

  def remove_state()
    return unless states.size > 1
    pos = rand(states.size)
    states.slice!(pos)
    states.each{|s| s.ceil(states.size)} # make sure all transitions are valid
  end

  def change_output()
    random_state.output = random_output
  end

private  
  # convenience
  def new_state(total_states = nil)
    total_states ||= states.size  # needed for add_state
    State.new(inputs, outputs, total_states)
  end

  def random_state()
    pos = rand(states.size)
    states[pos]
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
  
  def initialize(number_of_inputs, number_of_outputs, number_of_states)
    output ||= random_output(2**number_of_outputs)
    @output = output
    @transitions = Array.new(2**number_of_inputs).fill do |i|
      state_or_nil(number_of_states)
    end
  end

  def initialize_copy(from)
    @transitions, @output = from.transitions.clone, from.output
  end
  
  def change_output(max)
    @output = random_output(max)
  end
  
  def random_output(max)
    rand(max)
  end

  def ceil(max)
    # assures all transitions are to valid states
    # transitions will be 0 -> (height-1)
    @transitions.map!{|t| t % max unless t.nil?}
  end
end

def mutate(individual)
  mutant = individual.deep_copy
  #remove_state        if p(0)
  #add_state           if (states.size < 2 ? p(0.25) : p(0))
  mutant.states.each do |s|
    s.change_output(2**mutant.outputs) if p(0.022)
    s.transitions.map!{|t| p(0.04) ? state_or_nil(mutant.states.size) : t}
  end
  mutant
end

def cross(i1, i2)
  
end

def p(prob)
  rand() < prob
end

def state_or_nil(max)
  # returns an integer i or nil where
  # 0 <= i < max and P(i) ~= 2*P(nil)
  r = rand(max+1)
  r > max-1 ? nil : r
end


