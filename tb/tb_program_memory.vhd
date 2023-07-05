library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_program_memory is

		
end tb_program_memory;

architecture DUT of tb_program_memory is

	component program_memory is
		generic
		(
			memory_size		: in std_logic_vector(31 downto 0) := x"000003FF"
		);
		port
		(
			clk				: in std_logic;
			address_i		: in std_logic_vector(31 downto 0);
			-- outputs
			instruction_o	: out std_logic_vector(31 downto 0)
		);
	end component;

---------------------------------------------------------------------------------------------------
	signal clk				: std_logic;
	constant clock_period   : time := 20 ns;

	signal address_i		: std_logic_vector(31 downto 0) := (others => '0');
	-- outputs   
	signal instruction_o	: std_logic_vector(31 downto 0) := (others => '0');
			
---------------------------------------------------------------------------------------------------
	begin
	
	program_memory_test : program_memory
	generic map
	(
		memory_size 	=> x"000003FF"
	)
	port map
	(
		clk				=> clk,
		address_i		=> address_i,
		instruction_o	=> instruction_o
	);
	
-------------------------------------------------clock generator-----------------------------------
		clock_process: process
               begin
                    clk <= '0';
                    wait for clock_period/2;
                    clk <= '1';
                    wait for clock_period/2;
               end process;
---------------------------------------------------------------------------------------------------
	
	process
	begin
		address_i <= x"FFFFFFFF";
		wait for clock_period;
		address_i <= x"FFFFFFFF";
		wait for clock_period;
		address_i <= x"00000000";
		wait for clock_period;
		address_i <= x"00000001";
		wait for clock_period;
		address_i <= x"00000002";
		wait for clock_period;
		address_i <= x"00000003";
		wait for clock_period;
		address_i <= x"00000004";
		wait for clock_period;
		address_i <= x"00000005";
		wait for clock_period;
		address_i <= x"00000008";
		wait for clock_period;
		address_i <= x"FFFFFFFF";
		wait for clock_period;
		address_i <= x"00FFFFFF";
		wait for clock_period;
		wait;

	end process;
end DUT;
