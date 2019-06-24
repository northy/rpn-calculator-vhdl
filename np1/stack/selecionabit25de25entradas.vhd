entity selecionabit25de25entradas is
	port(ent : in bit_vector(25 downto 0);
		  ou : out bit);
end selecionabit25de25entradas;

architecture arch of selecionabit25de25entradas is
	begin
	ou <= ent(25);
end arch;