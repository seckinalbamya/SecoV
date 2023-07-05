--verified
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity program_memory is
	generic
	(
		memory_size		: in std_logic_vector(31 downto 0)
	);
	port
	(
		clk				: in std_logic;
		address_i		: in std_logic_vector(31 downto 0);
		-- outputs
		instruction_o	: out std_logic_vector(31 downto 0)
	);

end program_memory;

architecture arch of program_memory is
	
	type rom_type is array (0 to (to_integer(unsigned(memory_size)))) of std_logic_vector(31 downto 0);--4KB olması lazım???
	constant ROM : rom_type := (	
	
									0	=> x"00bec137",
									4	=> x"c2010113",
									8	=> x"00108093", 
									12	=> x"fe20cee3",
									16  => x"fff1c193",
									20	=> x"1e302f23",
									24  => x"0000f0b3",
									28  => x"fe0006e3",
									-- 32  => ,
									-- 36  => ,
									-- 40  => ,
									-- 44  => ,
									-- 48  => ,
									-- 52  => ,
									-- 56  => ,
									-- 60  => ,
									-- 64  => ,
									-- 68  => ,
									-- 72  => ,
									-- 76  => ,
									-- 80  => ,
									-- 84  => ,
									-- 88  => ,
									-- 92  => ,
									-- 96  => ,
									-- 100 => ,
									-- 104 => ,
									
									others 	=> x"00000000"
								);
begin
					
	process(address_i, clk)
	begin
		
		if(address_i >= x"00000000" and address_i < memory_size) then
			instruction_o <= ROM(to_integer(unsigned(address_i)));
		else
			instruction_o <= x"00000000";
		end if;
		
	end process;
	
	

end architecture;