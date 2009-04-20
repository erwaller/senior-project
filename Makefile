name = adder

$(name): $(name).vhdl
	ghdl -a $(name).vhdl
	ghdl -e $(name)

clean:
	rm -f work-obj93.cf
	rm -f *.o
	rm -f $(name)
