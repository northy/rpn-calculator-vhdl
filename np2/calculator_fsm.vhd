LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY calculator_fsm IS
    PORT(reset     : IN STD_LOGIC;
			clk       : IN STD_LOGIC;
			push      : IN STD_LOGIC;
			ptrflag   : IN STD_LOGIC;
			opin      : IN STD_LOGIC;
			input     : IN STD_LOGIC_VECTOR(7 downto 0);
			math_out  : IN STD_LOGIC_VECTOR(7 downto 0);
			stack_out : IN STD_LOGIC_VECTOR(7 downto 0);
			fsm_push  : OUT STD_LOGIC;
			stack_pop : OUT STD_LOGIC;
			stack_in  : OUT STD_LOGIC_VECTOR(7 downto 0);
			math_in1  : OUT STD_LOGIC_VECTOR(7 downto 0);
			math_in2  : OUT STD_LOGIC_VECTOR(7 downto 0);
			output    : OUT STD_LOGIC_VECTOR(7 downto 0));
END calculator_fsm;

ARCHITECTURE arch OF calculator_fsm IS
	TYPE t_state IS (init, NEN, insertn, waiting, read1, read2, wait11, wait12, wait21, wait22, wait23, wait31, wait32, wait33, wait34, wait35, wait36, wait37, processop);
	SIGNAL state : t_state;
	BEGIN
		PROCESS(clk)
		VARIABLE first_number, second_number, aux : STD_LOGIC_VECTOR(7 downto 0);
		BEGIN
			IF (rising_edge(clk)) THEN
				IF (reset = '1') THEN
					state <= init;
					first_number := (others => '0');
					second_number := (others => '0');
					aux := (others => '0');
					math_in1 <= (others => '0');
					math_in2 <= (others => '0');
					stack_pop <= '0';
					fsm_push <= '0';
					stack_in <= input;
					output <= "00000000";
				ELSE
					stack_pop <= '0';
					fsm_push <= '0';
					
					--update state
					CASE state IS
						WHEN init =>
							state <= NEN;
						WHEN NEN =>
							stack_in <= input;
							IF (push = '1') THEN
								state <= insertn;
							END IF;
						WHEN insertn =>
							IF (push = '0') THEN
								IF (ptrflag = '1') THEN
									state <= waiting;
								ELSIF (ptrflag = '0') THEN
									state <= NEN;
								END IF;
							END IF;
						WHEN waiting =>
							stack_in <= input;
							IF (push = '1') THEN
								state <= insertn;
							ELSIF (opin = '1') THEN
								state <= read1;
							END IF;
						WHEN read1 =>
							state <= wait11;
						WHEN wait11 =>
							state <= wait12;
						WHEN wait12 =>
							state <= read2;
						WHEN read2 =>
							state <= wait21;
						WHEN wait21 =>
							state <= wait22;
						WHEN wait22 =>
							state <= wait23;
						WHEN wait23 =>
							state <= processop;
						WHEN processop =>
							state <= wait31;
						WHEN wait31 =>
							state <= wait32;
						WHEN wait32 =>
							state <= wait33;
						WHEN wait33 =>
							state <= wait34;
						WHEN wait34 =>
							state <= wait35;
						WHEN wait35 =>
							state <= wait36;
						WHEN wait36 =>
							state <= wait37;
						WHEN wait37 =>
							IF (opin = '0') THEN
								IF (ptrflag = '1') THEN
									state <= waiting;
								ELSIF (ptrflag = '0') THEN
									state <= NEN;
								END IF;
							END IF;
					END CASE;
					
					--process outputs
					CASE state IS
						WHEN insertn =>
							fsm_push <= '1';
						WHEN read1 =>
							stack_pop <= '1';
						WHEN read2 =>
							stack_pop <= '1';
						WHEN wait12 =>
							first_number := stack_out;
						WHEN wait23 =>
							second_number := stack_out;
						WHEN processop =>
							math_in2 <= first_number;
							math_in1 <= second_number;
						WHEN wait34 =>
							stack_in <= math_out;
							output <= math_out;
						WHEN wait36 =>
							fsm_push <= '1';
						WHEN OTHERS =>
							null;
					END CASE;
					
				END IF;
			END IF;
		END PROCESS;
END arch;