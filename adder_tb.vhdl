ENTITY adder_tb IS
END adder_tb;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE std.textio.all;

-- test data source/sink
ARCHITECTURE text_io OF adder_tb IS
  COMPONENT adder
    PORT (
      clock, reset : IN STD_LOGIC;
      data_in      : IN UNSIGNED(3 DOWNTO 0);
      data_out     : OUT UNSIGNED(3 DOWNTO 0)
    );
  END COMPONENT;

  FOR DUT: adder USE ENTITY work.adder;

  CONSTANT period : TIME := 50 ns;
  SIGNAL clk      : STD_LOGIC := '0';
  SIGNAL rst_n    : STD_LOGIC;
  SIGNAL data_in, data_out  : UNSIGNED(3 DOWNTO 0);
BEGIN
  DUT : adder PORT MAP (
    clock => clk,
    reset => rst_n,
    data_in => data_in,
    data_out => data_out
  );
  
  generate_clock : PROCESS (clk) BEGIN
      clk <= NOT clk AFTER period/2;
  END PROCESS;
  
  rst_n <= '0',
           '1' AFTER 75 ns;

  PROCESS (clk, rst_n)
    FILE in0_file  : TEXT IS IN "in0.txt";
    FILE in1_file  : TEXT IS IN "in1.txt";
    FILE out_file  : TEXT IS OUT "out.txt";
    VARIABLE line_in  : LINE;
    VARIABLE line_out : LINE;
    VARIABLE data_in_tmp : INTEGER;
    VARIABLE input_tmp   : INTEGER;
    VARIABLE output_tmp  : INTEGER;
  BEGIN
    IF rst_n = '0' THEN
      data_in <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      IF NOT (ENDFILE(in0_file) OR ENDFILE(in1_file)) THEN
        -- place in0 in the upper two bits of data_in_tmp
        READLINE(in0_file, line_in);
        READ(line_in, input_tmp);
        data_in_tmp := input_tmp * 4;
        
        -- place in1 in the lower two bits of data_in_tmp
        READLINE(in1_file, line_in);
        READ(line_in, input_tmp);
        data_in_tmp := data_in_tmp + input_tmp;
        
        data_in <= TO_UNSIGNED(data_in_tmp, 4);
        
        output_tmp := TO_INTEGER(data_out);
        WRITE(line_out, output_tmp);
        WRITELINE(out_file, line_out);
      ELSE
        ASSERT FALSE
          REPORT "NONE. End of file!"
        SEVERITY FAILURE;
      END IF;
    END IF;
  END PROCESS;
END text_io;


