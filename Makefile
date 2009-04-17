name = hello_world

$(name): $(name).vhdl
	ghdl -a $(name).vhdl
	ghdl -e $(name)

clean:
	rm -f work-obj93.cf
	rm -f $(name).o
	rm -f e~$(name).o
	rm -f $(name)
