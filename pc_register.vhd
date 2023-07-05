--not verified
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;


entity pc_register is
	port
	(
		clk				: in std_logic;
		reset_i			: in std_logic;
		data_i			: in std_logic_vector(31 downto 0) := (others => '0');
		-- output(s)
		data_o			: out std_logic_vector(31 downto 0) := (others => '0')
	);

end pc_register;

architecture arch of pc_register is

	signal pc : std_logic_vector(31 downto 0) := (others => '0');
	
	begin
	
	process(clk,data_i)
	begin
	
		if reset_i = '1' then 
			pc <= x"00000000";
		elsif rising_edge(clk) then
			pc <= data_i;	
		end if;

    end process;
	
	data_o <= pc;
		
		
end architecture;



								

