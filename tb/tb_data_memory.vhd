library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_data_memory is

		
end tb_data_memory;

architecture DUT of tb_data_memory is

	component data_memory is
		generic
		(
			memory_size		: in std_logic_vector(31 downto 0) := x"000003FF"
		);
		port
		(
			clk			: in std_logic;
			wr_en_i		: in std_logic;
			address_i	: in std_logic_vector(31 downto 0);
			data_i		: in std_logic_vector(31 downto 0);
			-- outputs
			data_o		: out std_logic_vector(31 downto 0);
			--peripherals
			peripheral_i	: in std_logic_vector(15 downto 0) := x"0000";
			peripheral_o	: out std_logic_vector(15 downto 0)
		);
	end component;

---------------------------------------------------------------------------------------------------
	signal clk				: std_logic;
	constant clock_period   : time := 20 ns;
	
	signal address_i		: std_logic_vector(31 downto 0) := (others => '0');
	signal wr_en_i			: std_logic;
	signal data_i			: std_logic_vector(31 downto 0) := (others => '0');
    -- outputs
	signal data_o			: std_logic_vector(31 downto 0) := (others => '0');
---------------------------------------------------------------------------------------------------
	begin
	
	data_memory_test : data_memory
	port map
	(
		clk			=> clk,
		address_i	=> address_i,	
		wr_en_i		=> wr_en_i	,
		data_i		=> data_i,
		-- outputs
		data_o		=> data_o
		
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
		
		address_i 	<= x"00000000";
		data_i		<= x"00000000";
		wr_en_i		<= '0';
		wait for clock_period;
		address_i 	<= x"00000001";
		data_i		<= x"00000001";
		wr_en_i		<= '1';
		wait for clock_period;
		address_i 	<= x"00000002";
		data_i		<= x"00000002";
		wr_en_i		<= '1';
		wait for clock_period;
		address_i 	<= x"00000002";
		data_i		<= x"00000000";
		wr_en_i		<= '0';
		wait for clock_period;
		address_i 	<= x"00000001";
		data_i		<= x"00000001";
		wr_en_i		<= '1';
		wait for clock_period;
		address_i 	<= x"00000001";
		data_i		<= x"00000123";
		wr_en_i		<= '0';
		wait for clock_period;
		address_i 	<= x"00000002";
		data_i		<= x"00000321";
		wr_en_i		<= '0';
		wait for clock_period;
		address_i 	<= x"FFFFFFF0";
		data_i		<= x"00000321";
		wr_en_i		<= '0';
		wait for clock_period;
		address_i 	<= x"00FFFFFF";
		data_i		<= x"00000321";
		wr_en_i		<= '0';
		wait for clock_period;
		wait;

	end process;
end DUT;
