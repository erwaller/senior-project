require 'erb'

def erb (view)
  template = ERB.new(IO.read("#{view}.erb"))
  template.result
end

@test = 5
print erb :test
