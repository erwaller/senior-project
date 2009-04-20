require 'erb'

def erb (view)
  template = ERB.new(IO.read("#{view}.erb"))
  template.result
end

class Individual
  def init(inputs, outputs)
    @inputs = inputs
    @outputs = outputs
    @states = []
    add_state
  end

  def add_state()
    @states.push(State.new())
  end
end

class State
  def output=(out)
    
  end
  
  def transitions
    
  end
end

class StateTransition
  def
end

@states = [0, 1, 2, 3]
@inputs = 2
@outputs = 1
print erb :individual
