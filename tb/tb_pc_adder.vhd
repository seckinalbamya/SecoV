library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;


entity tb_pc_adder is
--  Port ( );
end tb_pc_adder;

architecture DUT of tb_pc_adder is

	component pc_adder is
		port
		(
			a_i			: in std_logic_vector(31 downto 0) := (others => '0');
			b_i			: in std_logic_vector(31 downto 0) := (others => '0');
			-- outputs
			data_o		: out std_logic_vector(31 downto 0):= (others => '0')
		);


	end component;
-------------------------------------------------Signals--------------------------------------------
	signal clk				: std_logic := '0';
	constant clock_period   : time 		:= 20 ns;

	
	signal a_i				: std_logic_vector(31 downto 0);
	signal b_i				: std_logic_vector(31 downto 0);
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
	pc_alu_test : pc_adder 
	port map
		(
			a_i		=> a_i,
			b_i		=> b_i,
			-- outputs  
			data_o	=> data_o
		);

	process
	begin
		--0+0
		a_i 	<= x"00000000";
		b_i 	<= x"00000000";
		wait for clock_period;
		--2+1
		a_i 	<= x"00000002";
		b_i 	<= x"00000001";
		wait for clock_period;
		---------------------------
		--extrem kosullar 1
		--F0000001 + 1
		a_i 	<= x"FFFFFFFF";
		b_i 	<= x"00000001";
		wait for clock_period;
		-- + 1
		a_i 	<= x"F0000001";
		b_i 	<= x"00000001";
		wait for clock_period;
		wait;

	end process;
	
end DUT;
