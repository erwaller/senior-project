-- clock stuff (better version below)
CONSTANT half_period : TIME := 12.5 ns;
...
clock_gen: PROCESS BEGIN
  clock <= '0' AFTER half_period, '1' AFTER 2 * half_period;
  WAIT FOR 2 * half_period;
END PROCESS clock_gen;


-- initialization stuff
tb: PROCESS BEGIN
  -- wait for global reset (?) to finish
  WAIT FOR 100 ns;
  -- initialize inputs
  reset <= '0'; data_in <= "00";
  WAIT FOR 100 ns;
  -- release reset
  reset <= '1';
  WAIT FOR 1 us;
...


-- test data source/sink
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE std.textio.all;
USE IEEE.std_logic_textio.all;

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

  DUT : tb_adder
    PORT MAP (
      clk   => clk,
      rst_n => rst_n,
      a     => stim_in,
      b     => stim_in,
      y     => response_out
    );
  
  generate_clock : PROCESS (clk) BEGIN
    clk <= NOT clk AFTER period/2;
  END PROCESS;

  rst_n <= '0',
           '1' AFTER 75 ns;

  PROCESS (clk, rst_x)
    FILE file_in  : TEXT IS IN "datain.txt";
    FILE file_out : TEXT IS IN "dataout.text";
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
          REPORT "End of file!"
        SEVERITY NOTE;
      END IF;
     END IF
  END PROCESS;

