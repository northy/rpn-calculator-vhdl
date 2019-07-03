library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity decimal_to_digits_binary is
	port(input: in std_logic_vector(7 downto 0);
		  digit0, digit1, digit2, digit3: out std_logic_vector(3 downto 0));
end decimal_to_digits_binary;

architecture comportamento of decimal_to_digits_binary is
	begin
	process(input)
		variable d0,d1,d2,d3 : integer;
		variable inp : integer;
		begin
			inp:=integer(to_integer(unsigned(input)));
			
			d0:=((inp mod 10)-(inp mod ((10)/10)))/((10)/10);
			d1:=((inp mod 100)-(inp mod ((100)/10)))/((100)/10);
			d2:=((inp mod 1000)-(inp mod ((1000)/10)))/((1000)/10);
			d3:=((inp mod 10000)-(inp mod ((10000)/10)))/((10000)/10);
			
			digit0 <= std_logic_vector(to_unsigned(d0, digit0'length));
			digit1 <= std_logic_vector(to_unsigned(d1, digit1'length));
			digit2 <= std_logic_vector(to_unsigned(d2, digit2'length));
			digit3 <= std_logic_vector(to_unsigned(d3, digit3'length));
	end process;
end comportamento;