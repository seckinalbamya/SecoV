--verified
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;


entity pc_adder is
	port
	(	
		a_i				: in std_logic_vector(31 downto 0) := (others => '0');
		b_i				: in std_logic_vector(31 downto 0) := (others => '0');
		-- outputs
		data_o		: out std_logic_vector(31 downto 0) := (others => '0')
	);

end pc_adder;

	architecture arch of pc_adder is

	begin
		
		data_o	<=	a_i	 +	b_i;
					

end architecture;



								

