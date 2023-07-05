library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;


entity tb_pc_register is
--  Port ( );
end tb_pc_register;

architecture DUT of tb_pc_register is

	component pc_register is
		port
		(
			clk				: in std_logic;
			reset_i			: in std_logic;
			data_i			: in std_logic_vector(31 downto 0) := (others => '0');
			-- output(s)
			data_o			: out std_logic_vector(31 downto 0) := (others => '0')
		);
	end component;
-------------------------------------------------Signals--------------------------------------------
	signal clk				: std_logic := '0';
	constant clock_period   : time 		:= 20 ns;
	
	
	signal reset_i			:  std_logic;
	signal data_i			:  std_logic_vector(31 downto 0);
	-- outputs        
	signal data_o			:  std_logic_vector(31 downto 0);

begin
-------------------------------------------------clock generator-----------------------------------
		clock_process: process
               begin
                    clk <= '0';
                    wait for clock_period/2;
                    clk <= '1';
                    wait for clock_period/2;
               end process;
---------------------------------------------------------------------------------------------------
	pc_register_test : pc_register
	port map
		(
			clk 	=> clk,
			reset_i => reset_i,
			data_i	=> data_i,
			-- outputs  
			data_o	=> data_o
		);

	process
	begin
		--0+0
		data_i 	<= x"00000001";
		reset_i	<= '0';
		wait for clock_period;
		data_i 	<= x"00000002";
		reset_i	<= '0';
		wait for clock_period;
		data_i 	<= x"00000001";
		reset_i	<= '1';
		wait for clock_period;
		data_i 	<= x"00000002";
		reset_i	<= '1';
		wait for clock_period;
		wait;

	end process;
	
end DUT;
