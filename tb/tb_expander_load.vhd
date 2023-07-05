library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_expander_load is

		
end tb_expander_load;

architecture DUT of tb_expander_load is

	component expander_load is
		port
		(
			clk			: in std_logic;
			data_i		: in std_logic_vector(31 downto 0);
			select_i	: in std_logic_vector(2 downto 0);
			-- output
			data_o		: out std_logic_vector(31 downto 0)
		);

	end component;

---------------------------------------------------------------------------------------------------
	signal clk				: std_logic := '0';
	constant clock_period  	: time 		:= 20 ns;
 
	signal data_i			: std_logic_vector(31 downto 0);
	signal select_i			: std_logic_vector(2 downto 0);
	-- outputs              
	signal data_o			: std_logic_vector(31 downto 0);
		
		
---------------------------------------------------------------------------------------------------
	begin

		-- ROM:
		expander_load_test: expander_load
		port map
		(
			clk			=> clk,		
			data_i		=> data_i,
			select_i	=> select_i,
			-- outputs
			data_o	 	=> data_o
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
		data_i <= "11001100110011001100110011001100";--lb
		select_i <= "000";
		wait for clock_period;
		data_i <= "11001100110011001100110011001100";--lh
		select_i <= "001";
		wait for clock_period;
		data_i <= "11001100110011001100110011001100";--lw
		select_i <= "010";
		wait for clock_period;
		data_i <= "11001100110011001100110011001100";--lbu
		select_i <= "011";
		wait for clock_period;
		data_i <= "11001100110011001100110011001100";--lhu
		select_i <= "100";
		wait for clock_period;
		data_i <= "00000000000000000000000000000000";--lb
		select_i <= "000";
		wait for clock_period;
		data_i <= "00000000000000000000000000000000";--lh
		select_i <= "001";
		wait for clock_period;
		data_i <= "00000000000000000000000000000000";--lw
		select_i <= "010";
		wait for clock_period;
		data_i <= "00000000000000000000000000000000";--lbu
		select_i <= "011";
		wait for clock_period;
		data_i <= "00000000000000000000000000000000";--lhu
		select_i <= "100";
		wait for clock_period;
		data_i <= "11111111111111111111111111111111";--lb
		select_i <= "000";
		wait for clock_period;
		data_i <= "11111111111111111111111111111111";--lh
		select_i <= "001";
		wait for clock_period;
		data_i <= "11111111111111111111111111111111";--lw
		select_i <= "010";
		wait for clock_period;
		data_i <= "11111111111111111111111111111111";--lbu
		select_i <= "011";
		wait for clock_period;
		data_i <= "11111111111111111111111111111111";--lhu
		select_i <= "100";
		wait for clock_period;
		wait;

	end process;
end DUT;
