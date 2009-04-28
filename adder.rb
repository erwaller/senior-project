require 'individual'

def pack(a, b)
  # Place two 2bit numbers side-by side in a 4bit number
  (a << 2) + b
end

# 2-bit adder (no carry-in or carry-out)
# 4 bits of input, 3 bits of output
# we want 7 distinct outputs, so give it 7 initial states
individual = Individual.new('adder', 0, 4, 3, 7)

16.times do |i|
  a, b = rand(4), rand(4)
  individual.transition(pack(a,b))
  puts "#{a} + #{b}, expected #{a+b}, got #{individual.output}"
end
