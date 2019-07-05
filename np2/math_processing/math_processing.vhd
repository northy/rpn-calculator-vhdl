library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity math_processing is
	port(number1, number2 : in std_logic_vector(7 downto 0);
		  add,sub,mult,div : in std_logic;
		  result : out std_logic_vector(7 downto 0));
end math_processing;

architecture arch of math_processing is
	begin
		
		process(add,sub,mult,div,number1,number2) is
			variable inp, inp1, inp2 : integer;
			begin
				inp1 := integer(to_integer(unsigned(number1)));
				inp2 := integer(to_integer(unsigned(number2)));
				
				if (add='1') then
					inp := inp1 + inp2;
				elsif (sub='1') then
					inp := inp1 - inp2;
				elsif (mult='1') then
					inp := inp1 * inp2;
				elsif (div='1') then
					inp := inp1 / inp2;
				end if;
				
				result <= std_logic_vector(to_unsigned(inp, result'length));
		end process;
end arch;