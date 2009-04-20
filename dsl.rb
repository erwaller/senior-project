# collection of states
@states = [0, 1, 2, 3]
puts "There are #{@states.size} states"
puts "they are:"
@states.each{|s| puts "s#{s}"}

# inputs
@inputs = 3
puts "There are #{@inputs} inputs"
puts "with #{@inputs**2} possible combinations, they are:"
(@inputs**2).times{|i| puts i.to_s(2)}

# outputs
@outputs = 2
puts "There are #{@outputs} outputs"
puts "with #{@outputs**2} possible combinations, they are:"
(@outputs**2).times{|i| puts i.to_s(2)}

# possible input combos 2**(number of inputs)
