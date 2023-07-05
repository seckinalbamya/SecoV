library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;


entity tb_cpu is
--  Port ( );
end tb_cpu;

architecture DUT of tb_cpu is

	component cpu is
		port
	   (
            clk_100			: in std_logic;
            --reset_i		: in std_logic;
            --peripherals
            peripheral_i	: in std_logic_vector(15 downto 0);
            peripheral_o	: out std_logic_vector(15 downto 0)
	   );

	end component;
-------------------------------------------------Signals--------------------------------------------
	constant clock_period   : time := 10 ns;

	signal clk_100			: std_logic := '0';
	signal reset_i			: std_logic := '0';

begin
-------------------------------------------------clock generator-----------------------------------
		clock_process: process
               begin
                    clk_100 <= '1';
                    wait for clock_period/2;
                    clk_100 <= '0';
                    wait for clock_period/2;
               end process;
---------------------------------------------------------------------------------------------------
	cpu_test : cpu 
	port map
		(
			clk_100		=> clk_100,
			--reset_i		=> '0'
			--peripherals
			peripheral_i=> x"0000"
		);

	process
	begin
		
		wait;

	end process;
	
end DUT;
