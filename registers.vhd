--verified
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity registers is
	port
	(
		clk				: in std_logic;
		reset_i			: in std_logic;
		a_address_i		: in std_logic_vector(4 downto 0);
		b_address_i		: in std_logic_vector(4 downto 0);
		c_address_i		: in std_logic_vector(4 downto 0);
		wr_en_i        	: in std_logic;

		c_data_i		: in std_logic_vector(31 downto 0);
		-- outputs	
		a_data_o		: out std_logic_vector(31 downto 0);
		b_data_o		: out std_logic_vector(31 downto 0)
	);
end registers;

architecture arch of registers is

	type registers_type is array (0 to 31) of std_logic_vector(31 downto 0);
	signal registers : registers_type := (others => x"00000000");

	begin
	
		sync_reset_write : process(clk,reset_i)
		begin
			if reset_i = '1' then
				registers <= (others => x"00000000");
			elsif rising_edge(clk) then
				if wr_en_i = '1' then
					registers(to_integer(unsigned(c_address_i))) <= c_data_i;
				end if;
			end if;
		end process;
	
	registers(0) <= x"00000000";
	
	a_data_o <= registers(to_integer(unsigned(a_address_i)));
	b_data_o <= registers(to_integer(unsigned(b_address_i)));

end architecture;



								

