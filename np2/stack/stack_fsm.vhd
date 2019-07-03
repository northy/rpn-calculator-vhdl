library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity stack_fsm is
	port(datain : in std_logic_vector(7 downto 0);
		  push, pop, clk, reset : in std_logic;
		  dataout : out std_logic_vector(7 downto 0);
		  ptrflag : out std_logic);
end stack_fsm;


architecture arch of stack_fsm is
	type estado is (init, still, push_op, pop_op);
	type arr is array (0 to 8) of std_logic_vector(7 downto 0);
	signal state : estado;
	signal stack : arr;
	signal p : std_logic;
	begin
		proc : process(clk)
		variable ptr : integer range 0 to 8;
		begin
			if (rising_edge(clk)) then
				if (ptr>=1) then
					ptrflag <= '1';
				else
					ptrflag <= '0';
				end if;
				if (reset='1') then
					state <= init;
					stack <= (others => (others => '0'));
					dataout <= "00000000";
					ptr := 0;
				else
					case state is
						when init =>
							state <= still;
						when still =>
							if (push='1' and p='1') then
								state <= push_op;
							elsif (pop='1' and p='1') then
								state <= pop_op;
							end if;
						when pop_op =>
							if (pop='0') then
								state <= still;
							end if;
						when push_op =>
							if (push='0') then
								state <= still;
							end if;
					end case;
					
					case state is
						when push_op =>
							if (ptr<8 and p='0') then
								ptr := ptr + 1;
								stack(ptr) <= datain;
								dataout <= datain;
							end if;
						when pop_op =>
							if (ptr>0 and p='0') then
								dataout <= stack(ptr);
								ptr := ptr - 1;
							end if;
						when others =>
							null;
					end case;
				end if;
			end if;
		end process proc;
		
		--debounce
		process(clk, push, pop)
		begin
			if (push='1' or pop='1') then
				p <= '1';
			else
				p <= '0';
			end if;
		end process;
end arch;