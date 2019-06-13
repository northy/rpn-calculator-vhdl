library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity stack_vhd is
	port(datain : in std_logic_vector(7 downto 0);
		  push, pop : in std_logic;
		  dataout : out std_logic_vector(7 downto 0) := (others => '0'));
end stack_vhd;

architecture arch of stack_vhd is
	type arr is array (0 to 7) of std_logic_vector(7 downto 0);
	signal stack : arr := (others=>(others=>'0'));
	begin
		process(push,pop)
 		variable ptr : integer range -1 to 7 := -1;
		begin
--			report "pointer: " & integer'image(ptr);
--			report "vector: " & integer'image(to_integer(unsigned(stack(ptr))));
			if (push='1') then
           		ptr := ptr + 1;
				stack(ptr) <= datain;
			elsif (pop='1') then
				dataout <= stack(ptr);
                ptr := ptr - 1;
			end if;
		end process;
end arch;