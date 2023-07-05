--verified
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity data_memory is
	generic
	(
		memory_size		: in std_logic_vector(31 downto 0)
	);
	port
	(
		clk				: in std_logic;
		wr_en_i			: in std_logic;
		address_i		: in std_logic_vector(31 downto 0);
		data_i			: in std_logic_vector(31 downto 0);
		-- outputs
		data_o			: out std_logic_vector(31 downto 0);
		--peripherals
		peripheral_i	: in std_logic_vector(15 downto 0);
		peripheral_o	: out std_logic_vector(15 downto 0)
		
	);

end data_memory;

architecture arch of data_memory is

	type ram_type is array (0 to (to_integer(unsigned(memory_size)))) of std_logic_vector(31 downto 0);
	signal RAM : ram_type 	:= (others => x"00000000");
	
	begin
					
	process(clk)
	begin
		if(rising_edge(clk)) then
			if (wr_en_i = '1' and address_i >= x"00000000" and address_i < memory_size) then
				RAM(to_integer(unsigned(address_i))) <= data_i;
			end if;
		end if;
	end process;	
	
	process(address_i)
	begin
		if(address_i >= x"00000000" and address_i <= memory_size) then
			data_o <= RAM(to_integer(unsigned(address_i)));
		else
			data_o <= x"00000000";
		end if;
	end process;
	
	peripheral_o <= RAM((to_integer(unsigned(memory_size)))-1)(15 downto 0);
	RAM(to_integer(unsigned(memory_size))) <= x"0000" & peripheral_i;
	
	
end architecture;