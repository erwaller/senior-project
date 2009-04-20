-- A state machine with 1 ins, 1 outs, and 4 states

ENTITY individual_0 IS PORT(
  clock, reset:    IN BIT;
  data_in:         IN BIT_VECTOR( 0 DOWNTO 0 );
  data_out:        OUT BIT_VECTOR ( 0 DOWNTO 0 )
  );
END individual_0;

ARCHITECTURE behavioral OF individual_0 IS
  TYPE state is (s0, s1, s2, s3);
  SIGNAL ps, ns : state;
BEGIN
  state_machine: PROCESS( clock ) BEGIN
    IF reset = '1' THEN
      ps <= s0;  -- s0 is always the initial state
    ELSIF (clock'EVENT AND clock = '1') THEN
      ps <= ns;
    END IF;
    -- "move" to current state
    CASE ps IS
      WHEN s0 =>
        -- output associated with this state
        data_out <= "0";
        -- select next state based on inputs
        CASE data_in IS
          WHEN "0" => ns <= s0;
          WHEN "1" => ns <= s1;
        END CASE;
      WHEN s1 =>
        -- output associated with this state
        data_out <= "0";
        -- select next state based on inputs
        CASE data_in IS
          WHEN "0" => ns <= s1;
          WHEN "1" => ns <= s2;
        END CASE;
      WHEN s2 =>
        -- output associated with this state
        data_out <= "1";
        -- select next state based on inputs
        CASE data_in IS
          WHEN "0" => ns <= s2;
          WHEN "1" => ns <= s3;
        END CASE;
      WHEN s3 =>
        -- output associated with this state
        data_out <= "1";
        -- select next state based on inputs
        CASE data_in IS
          WHEN "0" => ns <= s3;
          WHEN "1" => ns <= s0;
        END CASE;
    END CASE;
  END PROCESS state_machine;
END behavioral;
