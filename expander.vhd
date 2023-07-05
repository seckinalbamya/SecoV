--verified
library ieee;
use ieee.std_logic_1164.all;


entity expander is
	port
	(
		clk					: in std_logic;
		instruction_i		: in std_logic_vector(31 downto 0);
		immediate_select_i	: in std_logic_vector(2 downto 0);
		-- output
		data_o				: out std_logic_vector(31 downto 0)
	);

end expander;

	architecture arch of expander is
	
	begin
		
	data_o	<=  instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & --I Type
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & 
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & 
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & 
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & 
				instruction_i(31 downto 20)	when immediate_select_i = "000" else
				
				instruction_i(31 downto 12) & instruction_i(31) & instruction_i(31) & 			 --U type
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & 
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & 
				instruction_i(31) & instruction_i(31)  when immediate_select_i = "001" else
				
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & -- S type
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & 
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & 
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & 
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & 
				instruction_i(31 downto 25) & instruction_i(11 downto 7) when immediate_select_i = "010" else
				
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & --B type
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & 
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & 
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & 
				instruction_i(31) & instruction_i(31) & instruction_i(31) &
				instruction_i(31) & instruction_i(7) & instruction_i(30 downto 25) & instruction_i(11 downto 8) & '0' when immediate_select_i = "011" else
				
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & -- UJ type
				instruction_i(31) & instruction_i(31) & instruction_i(31) & instruction_i(31) & 
				instruction_i(31) & instruction_i(31) & instruction_i(31) &  
				instruction_i(31) & instruction_i(19 downto 12) & instruction_i(20) & instruction_i(30 downto 21) & '0' when immediate_select_i = "100" else
				
				x"00000000";

end architecture;