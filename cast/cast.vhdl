entity cast is
end cast;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture test of cast is
begin
  process
    variable a : integer;
    variable b : unsigned(3 downto 0);
  begin
    a := 3;
    b := to_unsigned(a, 4);
    b := "1001";
    a := to_integer(b);
    wait;
  end process;
end test;
