ENTITY source_tb IS
END source_tb;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all; -- requires the "--ieee=synopsys" flag
USE std.textio.all;
USE IEEE.std_logic_textio.all;

-- test data source/sink
ARCHITECTURE text_io OF source_tb IS
  COMPONENT tb_adder
    PORT (
      clk   : IN STD_LOGIC;
      rst_n : IN STD_LOGIC;
      a, b  : IN UNSIGNED(2 DOWNTO 0);
      y     : OUT UNSIGNED( 2 DOWNTO 0)
    );
  END COMPONENT;

  CONSTANT period : TIME := 50 ns;
  SIGNAL clk      : STD_LOGIC := '0';
  SIGNAL rst_n    : STD_LOGIC;
  SIGNAL a, b, y  : UNSIGNED(2 DOWNTO 0);
BEGIN
  generate_clock : PROCESS (clk) BEGIN
      clk <= NOT clk AFTER period/2;
  END PROCESS;
  
  rst_n <= '0',
           '1' AFTER 75 ns;
  
  PROCESS (a, b) BEGIN
    y <= a + b;
  END PROCESS;

  PROCESS (clk, rst_n)
    FILE file_in  : TEXT IS IN "in.txt";
    FILE file_out : TEXT IS OUT "out.txt";
    VARIABLE line_in  : LINE;
    VARIABLE line_out : LINE;
    VARIABLE input_tmp  : INTEGER;
    VARIABLE output_tmp : INTEGER;
  BEGIN
    IF rst_n = '0' THEN
      a <= (OTHERS => '0');
      b <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      IF NOT (ENDFILE(file_in)) THEN
        READLINE(file_in, line_in);
        READ(line_in, input_tmp);
        a <= CONV_UNSIGNED(input_tmp, 3);
        b <= CONV_UNSIGNED(input_tmp, 3);
        output_tmp := CONV_INTEGER(y);
        WRITE(line_out, output_tmp);
        WRITELINE(file_out, line_out);
      ELSE
        ASSERT FALSE
          REPORT "NONE. End of file!"
        SEVERITY FAILURE;
      END IF;
    END IF;
  END PROCESS;
END text_io;


