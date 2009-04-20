ENTITY clock is
  PORT (i0 : in bit; clk, reset : in bit; s : out bit);
END clock;

ARCHITECTURE something of clock is
TYPE state is (s0, s1);
SIGNAL cs, ns : state;
BEGIN

sm: -- i0 determines whether or not clk should be passed to the output
PROCESS (i0, clk, reset, cs, ns)
BEGIN
  -- Basic state transition event for any state machine
  IF reset = '1' THEN
    cs <= s0; -- Reset always resets to s0
  ELSIF (clk'EVENT AND clk = '1') THEN
    cs <= ns;
  END IF;
  
  CASE cs IS
    WHEN s0 =>
      s <= '0'; -- Each state has an associated output (or set of outputs)
      IF (i0 = '1') THEN
        ns <= s1;
      ELSE
        ns <= s0;
      END IF;
    WHEN s1 =>
      s <= '1';
      IF (i0 = '1') THEN
        ns <= s0;
      ELSE
        ns <= s1;
      END IF;
  END CASE;
END PROCESS sm;
  
END something;
