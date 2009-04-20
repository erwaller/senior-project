require 'erb'

def erb (view)
  template = ERB.new(IO.read("#{view}.erb"))
  template.result.gsub(/^\s+\n/, "")
end

class Fixnum
  def to_bv(length)
    self.to_s(2).rjust(length, '0')
  end
end

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

@individual = 1
@entity = "individual_#{@individual}"
@inputs = 2
@outputs = 1
@states = [
  {:transitions => [nil, 0, nil, 1], :output => 0},
  {:transitions => [1, nil, 0, 0], :output => 1},
]
print erb :individual
