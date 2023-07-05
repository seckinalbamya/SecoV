--not verified
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity alu is
	port
	(
		a_i			: in std_logic_vector(31 downto 0) := (others => '0');
		b_i			: in std_logic_vector(31 downto 0) := (others => '0');
		select_i	: in std_logic_vector(3 downto 0);
		-- outputs
		data_o		: out std_logic_vector(31 downto 0) := (others => '0');
		comparison_o: out std_logic_vector(2 downto 0)--signed and unsigned comparison result
	);

end alu;

	architecture arch of alu is
	
	signal slt_result 		: std_logic;
	signal sltu_result 		: std_logic;
	signal isequal_result 	: std_logic;

	begin
	
	slt_result 	<= '1'	when (signed(a_i) < signed(b_i)) else--slt
				   '0';
	sltu_result <= '1' 	when (unsigned(a_i) < unsigned(b_i)) else--sltu
				   '0';

	data_o		<=	a_i					+ 		b_i														when select_i = "0000" else--add
					a_i					- 		b_i														when select_i = "0001" else--sub
					std_logic_vector(shift_left(unsigned(a_i), to_integer(unsigned(b_i(4 downto 0)))))  when select_i = "0010" else--sll
					"0000000000000000000000000000000" & slt_result										when select_i = "0011" else--slt
					"0000000000000000000000000000000" & sltu_result										when select_i = "0100" else--sltu
					a_i					xor		b_i														when select_i = "0101" else--xor
					std_logic_vector(shift_right(unsigned(a_i), to_integer(unsigned(b_i(4 downto 0)))))	when select_i = "0110" else--srl
					std_logic_vector(shift_right(signed(a_i), to_integer(unsigned(b_i(4 downto 0))))) 	when select_i = "0111" else--sra
					a_i					or 		b_i														when select_i = "1000" else--or
					a_i					and 	b_i														when select_i = "1001" else--and
					x"00000000";
	
	isequal_result	<= '1' when a_i - b_i = "00000000" else '0';--equal out
	
	comparison_o	<= isequal_result & slt_result & sltu_result;
	
end architecture;



								

