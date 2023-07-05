--verified
library ieee;
use ieee.std_logic_1164.all;


entity expander_load is
	port
	(
		clk			: in std_logic;
		data_i		: in std_logic_vector(31 downto 0);
		select_i	: in std_logic_vector(2 downto 0);
		-- output
		data_o		: out std_logic_vector(31 downto 0)
	);

end expander_load;

architecture arch of expander_load is

begin
	
	data_o <= 	data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(7 downto 0) when select_i = "000" else--lb
				data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15) & data_i(15 downto 0) when select_i = "001" else--lh
				data_i when select_i = "010" else--lw
				"000000000000000000000000" & data_i(7 downto 0) when select_i = "011" else--lbu
				"0000000000000000" & data_i(15 downto 0) when select_i = "100" else--lhu
				x"00000000";
	

end architecture;