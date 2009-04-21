require 'erb'

class Fixnum
  def to_bv(length) # 3.to_bv(5) => 00011
    self.to_s(2).rjust(length, '0')
  end
end

class Individual
  def initialize(entity, id, ins, outs)
    # a state is an array of transitions, and an output
    # integer entries in the transition table represent
    # next states, and nil entries represent no transition
    # 
    # here's a sample state machine with 2 inputs, 1 output
    # and 2 states.
    #
    # inputs =>  00   01   10   11   | output 
    # s0     => [nil,   0, nil,   1] |   0
    # s1     => [1  , nil,   0,   0] |   1

    @id = id
    @entity = entity
    @architecture = "individual_#{@id}"

    # to keep this code simple there is a single unsigned
    # unsigned input array. if you want to do something like
    # add two 2-bit integers just put them side-by-side into
    # a 4-bit array
    @inputs = ins
    @outputs = outs
    @states = [
      {:transitions => [nil, 0, nil, 1], :output => 0},
      {:transitions => [1, nil, 0, 0], :output => 1},
    ]
  end
  
  def render()
    erb :individual
  end
private
  def erb (view)
    template = ERB.new(IO.read("#{view}.erb"))
    template.result(binding).gsub(/^\s+\n/, "")
  end
end

print Individual.new("adder", 1, 4, 4).render()

