library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity stack_fsm is
	port(datain : in std_logic_vector(7 downto 0);
		  push, pop, clk, clean : in std_logic;
		  dataout, testo : out std_logic_vector(7 downto 0));
end stack_fsm;
--

architecture arch of stack_fsm is
	type estado is (init, clear, still, push_op, pop_op);
	type arr is array (0 to 7) of std_logic_vector(7 downto 0);
	signal state_cur, state_next : estado;
	signal stack : arr;
	signal ptr : integer range -1 to 7;
	begin
		process(state_cur, push, pop, clean, ptr)
		begin
			case state_cur is
				when init =>
					state_next <= clear;
				when clear =>
					if (clean='0') then
						state_next <= still;
					else
						state_next <= state_cur;
					end if;
				when still =>
					if (clean='1') then
						state_next <= clear;
					elsif (push='1' and ptr<7) then
						state_next <= push_op;
					elsif (pop='1' and ptr>=0) then
						state_next <= pop_op;
					else
						state_next <= state_cur;
					end if;
				when pop_op =>
					if (pop='0') then
						state_next <= still;
					else
						state_next <= state_cur;
					end if;
				when push_op =>
					if (push='0') then
						state_next <= still;
					else
						state_next <= state_cur;
					end if;
			end case;
		end process;
	
		process(clk)
		begin
			if (clk'event and clk='1') then
				state_cur <= state_next;
			else
				state_cur <= state_cur;
			end if;
			
--			testo(0) <= push;
--			testo(1) <= pop;
			report estado'image(state_cur);
			end process;
			
		process(state_cur, ptr)
		variable ptmp : integer range -1 to 7;
		begin
			report "stack(1): " & integer'image(to_integer(unsigned(stack(1))));
			report "ptr: " & integer'image(ptr);
			ptmp := ptr;
			case state_cur is
				when clear =>
					testo <= "10000000";
					stack(0) <= "00000000";
					stack(1) <= "00000000";
					stack(2) <= "00000000";
					stack(3) <= "00000000";
					stack(4) <= "00000000";
					stack(5) <= "00000000";
					stack(6) <= "00000000";
					stack(7) <= "00000000";
					dataout <= "00000000";
					ptmp := -1;
					ptr <= -1;
				when push_op =>
					testo <= "00000001";
					report "patr: " & integer'image(ptr);
               ptmp := ptmp + 1;
					report "patr: " & integer'image(ptr);
					stack(ptr+1) <= datain;
					ptr <= ptr + 1;
				when pop_op =>
					testo <= "00000010";
					report "pbtr: " & integer'image(ptr);
					dataout <= stack(ptr);
					ptmp := ptmp - 1;
					ptr <= ptr - 1;
					report "pbtr: " & integer'image(ptr);
				when others =>
					testo <= "10101010";
            end case;
				--ptr <= ptmp;
		end process;
end arch;