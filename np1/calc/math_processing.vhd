library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity math_processing is
	port(add,sub,mult,div : in std_logic;
		  number : in std_logic_vector(7 downto 0);
		  result : out std_logic_vector(7 downto 0));
end math_processing;

architecture arch of math_processing is
	signal outp : std_logic_vector(7 downto 0);
	signal const : integer;
	begin
		const <= 6;
		
		process(add,sub,mult,div) is
			variable inp : integer;
--			variable const : integer;
			begin
				inp := integer(to_integer(signed(number)));
--				inp := integer(to_integer(signed(outp)));
--				const := integer(to_integer(signed(number)));
				
				if (add='1') then
					inp := inp + const;
				elsif (sub='1') then
					inp := inp - const;
				elsif (mult='1') then
					inp := inp * const;
				elsif (div='1') then
					inp := inp / const;
				end if;
				
				outp <= std_logic_vector(to_signed(inp, outp'length));
		end process;
		
		result <= outp;
end arch;